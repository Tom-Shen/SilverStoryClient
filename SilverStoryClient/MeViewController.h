//
//  MeViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 10/31/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginViewController.h"

#import "CustomerOrdersViewController.h"

@interface MeViewController : UITableViewController <LoginViewControllerDelegate, CustomerOrderViewControllerDelegate>

@property (nonatomic, strong) NSNumber *userID;

@end
