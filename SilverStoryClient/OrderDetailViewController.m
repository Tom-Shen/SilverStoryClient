//
//  OrderDetailViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/28/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (IBAction)close:(id)sender {
    [self.delegate orderDetailViewControllerCloseButtonClicked:self];
}

@end
