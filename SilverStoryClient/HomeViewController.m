//
//  ViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 9/27/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+Resize.h"
#import "WCProduct.h"
#import "WCImageAttribute.h"

#import "NSURLSessionDataTask+createDataTask.h"

@interface HomeViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *arrivalCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *clearanceCollectionView;
@end

@implementation HomeViewController {
    NSURLSessionDataTask *dataTask;
    
    WCProduct *selectedProduct;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.allProducts = [NSMutableArray arrayWithCapacity:30];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownload:) name:WCHomeProductImageFinishDownloadingNotification object:nil];
    }
    return self;
}

- (void)finishDownload:(NSNotification *)sender {
    [self.arrivalCollectionView reloadData];
    [self.clearanceCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self downloadProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.clearanceCollectionView) {
        return [self.clearanceProducts count];
    } else if (collectionView == self.arrivalCollectionView) {
        return [self.arrivalProducts count];
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Collection View is invalid" userInfo:nil];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1000];
    
    WCProduct *product;
    
    if (collectionView == self.arrivalCollectionView) {
        product = self.arrivalProducts[indexPath.row];
    } else if (collectionView == self.clearanceCollectionView) {
        product = self.clearanceProducts[indexPath.row];
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Collection View is invalid" userInfo:nil];
    }
    
    imageView.image = [product.productThumbnail resizedImageWithBounds:CGSizeMake(146, 146)];
    
    return cell;
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

- (void)parseImages:(WCProduct*)input {
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
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self filterData];
    [self.arrivalCollectionView reloadData];
    [self.clearanceCollectionView reloadData];
}

- (void)filterData {
    self.clearanceProducts = [NSMutableArray arrayWithCapacity:10];
    self.arrivalProducts = [NSMutableArray arrayWithCapacity:10];
    
    for (WCProduct *product in self.allProducts) {
        for (NSString *categoryName in product.productCategories) {
            if ([categoryName isEqualToString:@"New Arrival"]) {
                [self.arrivalProducts addObject:product];
            } else if ([categoryName isEqualToString:@"Clearance"]) {
                [self.clearanceProducts addObject:product];
            }
        }
    }
    
    for (WCProduct *product in self.arrivalProducts) {
        [product downloadHomeIcon];
    }
    
    for (WCProduct *product in self.clearanceProducts) {
        [product downloadHomeIcon];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    WCProduct *product;
    if (collectionView == self.clearanceCollectionView) {
        product = self.clearanceProducts[indexPath.row];
    } else if (collectionView == self.arrivalCollectionView) {
        product = self.arrivalProducts[indexPath.row];
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Collection View is invalid" userInfo:nil];
    }
    selectedProduct = product;
    [self performSegueWithIdentifier:@"ShowProduct" sender:collectionView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProduct"]) {
        UINavigationController *navController = segue.destinationViewController;
        
        ProductDetailsViewController *controller = (ProductDetailsViewController *)navController.topViewController;
        
        controller.delegate = self;
        controller.inputProduct = selectedProduct;
    }
}

#pragma mark - Product Detail View Controller Delegate

- (void)productDetailViewControllerDidCancel:(ProductDetailsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
