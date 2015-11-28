//
//  ProductViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 9/27/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *allCategory;
@property (nonatomic, strong) NSMutableArray *categoryToDisplay;

- (void)goBack:(UIBarButtonItem *)sender;

- (void)filterData;

@end
