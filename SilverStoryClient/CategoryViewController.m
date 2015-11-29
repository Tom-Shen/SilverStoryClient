//
//  ProductViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 9/27/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "CategoryViewController.h"

#import "WCCategory.h"

#import "UIImage+Resize.h"

#import "ProductViewController.h"

#import "NSURLSessionDataTask+createDataTask.h"

@interface CategoryViewController ()
@property (strong, nonatomic) UIBarButtonItem *backBarButtonItem;
@end

@implementation CategoryViewController {
    WCCategory *selectedCategory;
    WCCategory *previousCategory;
    WCCategory *productCategory;
    
    int selectedID;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishImageDownload:) name:WCCategoryImageFinishDownloadingNotification object:nil];
        selectedID = 0;
        
        self.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WCCategoryImageFinishDownloadingNotification object:nil];
    NSLog(@"Dealloc %@", self);
}

- (void)goBack:(UIBarButtonItem *)sender {
    NSLog(@"Rewind");
    selectedCategory = previousCategory;
    selectedID = selectedCategory.categoryId.intValue;
    previousCategory = [self filterPreviousCategoryWithChildCategory:selectedCategory];
    [self filterData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downloadCategoryData];
    
    // Load Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self updateUI];
    
    [self clearData];
}

- (void)updateUI {
    if (selectedID == 0) {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    } else {
        [self.navigationItem setLeftBarButtonItem:self.backBarButtonItem animated:YES];
    }
    
    if (selectedCategory == nil) {
        self.navigationItem.title = @"Select Category";
    } else {
        self.navigationItem.title = selectedCategory.categoryName;
    }
}

- (void)refreshData:(UIRefreshControl *)sender {
    NSLog(@"Refresh");
    [self clearData];
    [self downloadCategoryData];
}

- (void)clearData {
    [self.allCategory removeAllObjects];
    [self.categoryToDisplay removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)categoryHasChild:(WCCategory *)category {
    int categoryId = category.categoryId.intValue;
    for (WCCategory *resultCategory in self.allCategory) {
        if (resultCategory.categoryParentId.intValue == categoryId) {
            return YES;
        }
    }
    return NO;
}

- (nullable WCCategory *)filterPreviousCategoryWithChildCategory:(nonnull WCCategory *)child {
    int childParentID = child.categoryParentId.intValue;
    for (WCCategory *category in self.allCategory) {
        if (category.categoryId.intValue == childParentID) {
            return category;
        }
    }
    return nil;
}

- (void)filterData {    
    NSMutableArray *tmpCategoryToDisplay = [NSMutableArray arrayWithCapacity:10];
    
    for (WCCategory *category in self.allCategory) {
        if ([category.categoryParentId intValue] == selectedID) {
            if (![category.categoryName isEqualToString:@"Clearance"] && ![category.categoryName isEqualToString:@"New Arrival"]) {
                [tmpCategoryToDisplay addObject:category];
            }
        }
    }
    if ([tmpCategoryToDisplay count] == 0) {
        [self performSegueWithIdentifier:@"ShowProducts" sender:nil];
        NSLog(@"View Product");
        return;
    } else {
        self.categoryToDisplay = tmpCategoryToDisplay;
    }
    
    [self.categoryToDisplay sortUsingSelector:@selector(compareName:)];
    
    [self updateUI];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.allCategory.count > 0) {
        selectedID = selectedCategory.categoryId.intValue;
        [self filterData];
    }
}

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *productCategories = dictionary[@"product_categories"];
    if (!productCategories) {
        NSLog(@"Error : Expected productCategories array");
        [self endDownloadWithSuccess:NO];
        return;
    }
    
    for (NSDictionary *categoryDict in productCategories) {
        if (categoryDict == nil) {
            NSLog(@"Expected categoryDict Dictionary");
            continue;
        }
        WCCategory *category = [self createCategoryFromDictionary:categoryDict];
        [self.allCategory addObject:category];
    }
    
    [self endDownloadWithSuccess:YES];
}

- (nonnull WCCategory *)createCategoryFromDictionary:(NSDictionary *)categoryDict {
    WCCategory *category = [[WCCategory alloc] init];
    category.categoryId = categoryDict[@"id"];
    category.categoryImageURL = categoryDict[@"image"];
    category.categoryDescription = categoryDict[@"description"];
    category.categorySlug = categoryDict[@"slug"];
    category.categoryName = categoryDict[@"name"];
    category.categoryDisplay = categoryDict[@"display"];
    category.categoryItemsCount = categoryDict[@"count"];
    category.categoryParentId = categoryDict[@"parent"];
    [category downloadImage];
    return category;
}

- (void)finishImageDownload:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (NSDictionary *)parseJSONFromData:(NSData *)data {
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"JSON Error : %@", error);
        return nil;
    }
    
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"JSON Error : Expected Dictionary");
        return nil;
    }
    
    return JSONObject;
}

- (void)downloadCategoryData {
    NSString *urlPrefix = [CLIENT_URL stringByAppendingString:CATEGORY_CLIENT_URL];
    NSString *urlSuffix = [NSString stringWithFormat:@"?oauth_consumer_key=%@", CLIENT_CONSUMERS_KEY];
    NSString *urlString = [urlPrefix stringByAppendingString:urlSuffix];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [NSURLSessionDataTask createNormalDataTaskWithURL:requestURL successBlock:^(NSData *data) {
        NSDictionary *dictionary = [self parseJSONFromData:data];
        if (dictionary == nil) {
            NSLog(@"Error : Expected Dictionary");
            [self endDownloadWithSuccess:NO];
        } else {
            NSLog(@"Category Download Successful");
            [self parseDictionary:dictionary];
        }
    } failureBlock:^(NSError *error, NSHTTPURLResponse *response) {
        [self endDownloadWithSuccess:NO];
    }];
    [dataTask resume];
}

- (void)endDownloadWithSuccess:(BOOL)success {
    if (!success) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There are a problem downloading the required data" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"I got it" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self filterData];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.categoryToDisplay == nil) {
        return 0;
    } else if ([self.categoryToDisplay count] == 0) {
        return 1;
    } else {
        return [self.categoryToDisplay count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"ProductCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    if (self.allCategory.count != 0) {
        if (self.categoryToDisplay.count == 0) {
            [self performSegueWithIdentifier:@"ShowProducts" sender:self];
        } else {
            WCCategory *category = self.categoryToDisplay[indexPath.row];
            cell.textLabel.text = category.categoryName;
            UIImage *thumbnailImage = category.categotyImage;
            if (thumbnailImage != nil) {
                thumbnailImage = [thumbnailImage resizedImageWithBounds:CGSizeMake(44, 44)];
                cell.imageView.image = thumbnailImage;
            } else {
                cell.imageView.image = nil;
            }
        }
    } else {
        cell.textLabel.text = @"No Category Found";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.categoryToDisplay count] > 0) {
        WCCategory *category = self.categoryToDisplay[indexPath.row];
        selectedID = [category.categoryId intValue];
        if ([self categoryHasChild:category]) {
            selectedCategory = category;
            previousCategory = [self filterPreviousCategoryWithChildCategory:selectedCategory];
        } else {
            productCategory = category;
        }
        [self.categoryToDisplay removeAllObjects];
        [self filterData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProducts"]) {
        ProductViewController *controller = [segue destinationViewController];
        controller.inputCategory = productCategory;
    }
}

@end
