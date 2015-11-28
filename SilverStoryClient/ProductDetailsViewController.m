//
//  ProductDetailsViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 10/11/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "ProductDetailsViewController.h"

@interface ProductDetailsViewController ()
@end

@implementation ProductDetailsViewController {
    NSMutableArray *pageViews;
    NSMutableArray *pageImages;
}

- (void)loadImageCollectionView:(NSNotification *)sender {
    [self.imageCollectionView reloadData];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImageCollectionView:) name:WCProductImageArrayDidFinishNotification object:nil];
    }
    return self;
}

- (void)updatePriceLabel {
    NSString *regularPrice;
    NSString *salePrice;
    
    if (![self.inputProduct.productRegularPrice isEqual:[NSNull null]]) {
        regularPrice = (NSString *)self.inputProduct.productRegularPrice;
    } else {
        regularPrice = nil;
    }
    
    if (![self.inputProduct.productSalePrice isEqual:[NSNull null]]) {
        salePrice = (NSString *)self.inputProduct.productSalePrice;
    } else {
        salePrice = nil;
    }
    
    if (salePrice == nil && regularPrice != nil) {
        self.priceLabel.text = regularPrice;
    } else if (regularPrice.intValue == 0 && salePrice != nil) {
        self.priceLabel.text = salePrice;
    } else if (regularPrice == nil && salePrice == nil) {
        self.priceLabel.text = @"Price Unknown";
    } else {
        // Figure out the conbined string and put it into a mutable attributed string.
        NSString *conbinedString = [NSString stringWithFormat:@"%@   %@", regularPrice, salePrice];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:conbinedString];
        
        // Get the range of both price string
        NSRange regularPriceRange = [conbinedString rangeOfString:regularPrice];
        NSRange salePriceRange = [conbinedString rangeOfString:salePrice];
        
        // Add strikethrough for regular price
        [attributedString addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor blackColor]} range:regularPriceRange];
        
        // Add underline for sale price and change text color to red.
        [attributedString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor redColor],NSForegroundColorAttributeName:[UIColor redColor]} range:salePriceRange];
        
        // Set the label's attributed string text value.
        self.priceLabel.attributedText = attributedString;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.inputProduct.productTitle;
    
    self.descriptionWebView.delegate = self;
    
    //[self.descriptionWebView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    NSData *data = [self.inputProduct.productDescription dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *baseURL = [NSURL URLWithDataRepresentation:data relativeToURL:nil];
    
    [self.descriptionWebView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseURL];
    
    self.descriptionWebView.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self updatePriceLabel];
    
    [self.inputProduct downloadImageArray];
    
    self.noImageLabel.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 136;
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        return 61;
    } else if (indexPath.row == 3 && indexPath.section == 0) {
        UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        [self.descriptionWebView sizeToFit];
        CGSize size = [self.descriptionWebView sizeThatFits:cell.contentView.bounds.size];
        CGRect frame = self.descriptionWebView.frame;
        frame.size.height = size.height;
        frame.size.width = self.tableView.bounds.size.width - 20;
        self.descriptionWebView.frame = frame;
        
        // [self.descriptionWebView sizeToFit];
        
        CGPoint center = self.descriptionWebView.center;
        center.x = self.tableView.center.x;
        self.descriptionWebView.center = center;
        
        //[self updateViewConstraints];
        
        return self.descriptionWebView.frame.size.height + 20;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self.delegate productDetailViewControllerDidCancel:self];
}

- (void)dealloc {
    NSLog(@"Dealloc %@", self);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.tableView reloadData];
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *array = self.inputProduct.allImages;
    if (array == nil) {
        return 0;
    } else {
        return array.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:1000];
    NSArray *images = self.inputProduct.allImages;
    imageView.image = images[indexPath.row];
    if (images.count == 0) {
        self.noImageLabel.hidden = NO;
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
