//
//  ProductViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 10/3/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "ProductViewController.h"
#import "CategoryViewController.h"

#import "WCProduct.h"
#import "WCProductCell.h"

#import "WCImageAttribute.h"

#import "UIImage+Resize.h"

#import "NSURLSessionDataTask+createDataTask.h"

@interface ProductViewController ()

@end

@implementation ProductViewController {
    NSURLSessionDataTask *dataTask;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.allProducts = [NSMutableArray arrayWithCapacity:50];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishImageDownload:) name:WCProductImageFinishDownloadingNotification object:nil];
    }
    return self;
}

- (void)finishImageDownload:(NSNotification *)sender {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:WCProductNothingFoundCellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:WCProductNothingFoundCellIdentifier];
    
    cellNib = [UINib nibWithNibName:WCProductCellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:WCProductCellIdentifier];
    
    self.title = self.inputCategory.categoryName;
    
    self.tableView.rowHeight = 80;
    
    [self downloadProduct];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    NSLog(@"Input Category Name %@", self.inputCategory.categoryName);
}

- (void)filterData {
    self.productsToDisplay = [NSMutableArray arrayWithCapacity:25];
    for (WCProduct *product in self.allProducts) {
        for (NSString *categoryName in product.productCategories) {
            if ([categoryName isEqualToString:self.inputCategory.categoryName]) {
                [self.productsToDisplay addObject:product];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)downloadProduct {
    NSString *URLPrefix = [CLIENT_URL stringByAppendingString:PRODUCT_CLIENT_URL];
    NSString *URLSuffix = [NSString stringWithFormat:@"?oauth_consumer_key=%@", CLIENT_CONSUMERS_KEY];
    NSString *URLString = [URLPrefix stringByAppendingString:URLSuffix];
    NSURL *clientURL = [NSURL URLWithString:URLString];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    dataTask = [NSURLSessionDataTask createNormalDataTaskWithURL:clientURL successBlock:^(NSData *data) {
        NSDictionary *dictionary = [self parseJSONFromData:data];
        if (dictionary == nil) {
            NSLog(@"Error : Expected Dictionary");
            [self endDownloadWithSuccess:NO];
        } else {
            [self parseDictionary:dictionary];
        }
    } failureBlock:^(NSError *error, NSHTTPURLResponse *response) {
        [self endDownloadWithSuccess:NO];
    }];
     
    [dataTask resume];
}

- (void)dealloc {
    [dataTask cancel];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Dealloc %@", self);
}

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *products = dictionary[@"products"];
    
    if (products == nil) {
        NSLog(@"Error : Requires Product Array");
        [self endDownloadWithSuccess:NO];
    }
    
    for (NSDictionary *productDict in products) {
        if (productDict == nil) {
            NSLog(@"Error : Expected productDict Dictionary");
            continue;
        }
        
        WCProduct *product = [self createProductFromDictionary:productDict];
        [product downloadImage];
        [self.allProducts addObject:product];
    }
    
    [self endDownloadWithSuccess:YES];
}

- (nonnull WCProduct *)createProductFromDictionary:(NSDictionary *)dictionary {
    WCProduct *product = [[WCProduct alloc] init];
    product.productTitle = dictionary[@"title"];
    product.productSKU = dictionary[@"sku"];
    product.productSalePrice = dictionary[@"sale_price"];
    product.productCategories = dictionary[@"categories"];
    product.productImages = dictionary[@"images"];
    product.productRegularPrice = dictionary[@"regular_price"];
    product.productDescription = dictionary[@"description"];
    [self parseImages:product];
    return product;
}

- (void)parseImages:(WCProduct *)input {
    NSArray *allImages = input.productImages;
    if (allImages == nil) {
        NSLog(@"Error : Expected allImages array");
        return;
    }
    
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:10];
    
    for (NSDictionary *imageDictionary in allImages) {
        WCImageAttribute *attribute = [[WCImageAttribute alloc] initWithDictionary:imageDictionary];
        if (attribute == nil) {
            NSLog(@"Error : Expected Attribute");
            continue;
        }
        [attributes addObject:attribute];
    }
    
    input.productImages = attributes;
}

- (void)endDownloadWithSuccess:(BOOL)success {
    if (!success) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There are an error while downloading the product informations" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"I got it" style:UIAlertActionStyleCancel handler:nil]];
    }
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self filterData];
    [self.tableView reloadData];
}

- (void)refresh:(UIRefreshControl *)sender {
    NSLog(@"Refresh");
    [self clearData];
    [self downloadProduct];
}

- (void)clearData {
    [self.productsToDisplay removeAllObjects];
    [self.allProducts removeAllObjects];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.productsToDisplay.count == 0) {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WCProduct *product = self.productsToDisplay[indexPath.row];
    [self performSegueWithIdentifier:@"ShowProduct" sender:product];
}

- (NSString * _Nullable)formatPrice:(nonnull NSDecimalNumber *)price {
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setCurrencyCode:@"usd"];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return [formatter stringFromNumber:price];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProduct"]) {
        UINavigationController *navController = segue.destinationViewController;
        ProductDetailsViewController *controller = (ProductDetailsViewController *)navController.topViewController;
        controller.inputProduct = sender;
        controller.delegate = self;
    }
}

#pragma mark - Product View Controller Delegate

- (void)productDetailViewControllerDidCancel:(ProductDetailsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Dismiss");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.productsToDisplay == nil) {
        return 0;
    } else if (self.productsToDisplay.count == 0) {
        return 1;
    } else {
        return [self.productsToDisplay count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.productsToDisplay.count != 0) {
        WCProductCell *cell = [tableView dequeueReusableCellWithIdentifier:WCProductCellIdentifier];
        
        WCProduct *product = self.productsToDisplay[indexPath.row];
        
        cell.nameLabel.text = product.productTitle;
        
        cell.skuLabel.text = product.productSKU;
        
        if ([product.productSalePrice isEqual:[NSNull null]]) {
            if ([product.productRegularPrice isEqual:[NSNull null]]) {
                cell.priceLabel.text = @"Price Unknown";
            } else {
                cell.priceLabel.text = (NSString *)product.productRegularPrice;
            }
        } else {
            cell.priceLabel.text = cell.priceLabel.text = (NSString *)product.productSalePrice;
        }
        
        UIImage *thumbnailImage = product.productThumbnail;
        
        if (thumbnailImage != nil) {
            UIImage *resizedThumbnailImage = [thumbnailImage resizedImageWithBounds:CGSizeMake(80, 80)];
            cell.thumbnailImageView.image = resizedThumbnailImage;
        }
        
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:WCProductNothingFoundCellIdentifier];
    }
}

@end
