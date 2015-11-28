//
//  ButtonContainer.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/1/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "ButtonContainer.h"

@implementation ButtonContainer

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return self.button;
    }
    return view;
}

@end
