//
//  OrderDetailViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/28/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WCUserOrder.h"

@class OrderDetailViewController;

@protocol OrderDetailViewControllerDelegate <NSObject>

- (void)orderDetailViewControllerCloseButtonClicked:(OrderDetailViewController *)controller;

@end

@interface OrderDetailViewController : UITableViewController

@property (nonatomic, weak) id <OrderDetailViewControllerDelegate> delegate;

@property (nonatomic, strong) WCUserOrder *inputOrder;

@end
