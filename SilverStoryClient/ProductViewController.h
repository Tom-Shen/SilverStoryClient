//
//  ProductViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 10/3/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WCCategory.h"

#import "ProductDetailsViewController.h"

#import "AppDelegate.h"

@interface ProductViewController : UITableViewController <ProductDetailViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *allProducts;

@property (nonatomic, strong) NSMutableArray *productsToDisplay;

@property (nonatomic, strong) WCCategory *inputCategory;

@end
