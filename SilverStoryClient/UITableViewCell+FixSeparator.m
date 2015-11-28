//
//  UITableViewCell+FixSeparator.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/25/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "UITableViewCell+FixSeparator.h"

@implementation UITableViewCell (FixSeparator)

- (void)fixSeparator {
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"separatorView"]) {
            subview.hidden = NO;
        }
        
        NSLog(@"%@", NSStringFromClass(subview.class));
    }
}

@end
