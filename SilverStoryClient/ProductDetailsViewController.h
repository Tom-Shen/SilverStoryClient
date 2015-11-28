//
//  ProductDetailsViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 10/11/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WCProduct.h"

@class ProductDetailsViewController;

@protocol ProductDetailViewControllerDelegate <NSObject>

@optional

- (void)productDetailViewControllerDidCancel:(ProductDetailsViewController *)controller;

@end

@interface ProductDetailsViewController : UITableViewController <UIWebViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) WCProduct *inputProduct;

@property (strong, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *noImageLabel;

@property (strong, nonatomic) id <ProductDetailViewControllerDelegate> delegate;

@end
