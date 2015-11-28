//
//  LoginViewController.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/1/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

@optional

- (void)loginViewController:(LoginViewController *)controller didFinishWithUserID:(int)userID;

@end

@interface LoginViewController : UITableViewController

@property (nonatomic, strong) id <LoginViewControllerDelegate> delegate;

@end
