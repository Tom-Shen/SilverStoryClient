//
//  ScrollViewContainer.m
//  SilverStoryClient
//
//  Created by Tom Shen on 10/31/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return self.scrollView;
    }
    return view;
}

@end
