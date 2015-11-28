//
//  ViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 9/27/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductDetailsViewController.h"

@interface HomeViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, ProductDetailViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *allProducts;

@property (nonatomic, strong) NSMutableArray *arrivalProducts;

@property (nonatomic, strong) NSMutableArray *clearanceProducts;

@end

