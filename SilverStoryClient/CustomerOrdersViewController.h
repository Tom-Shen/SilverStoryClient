//
//  CustomerOrdersViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/7/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCUser.h"
#import "OrderDetailViewController.h"

@class CustomerOrdersViewController;

@protocol CustomerOrderViewControllerDelegate <NSObject>

- (void)customerOrderViewControllerDidCancel:(CustomerOrdersViewController *)controller;

@end

@interface CustomerOrdersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, OrderDetailViewControllerDelegate>

@property (nonatomic, strong) WCUser *inputUser;

@property (nonatomic, weak) id <CustomerOrderViewControllerDelegate> delegate;

@end
