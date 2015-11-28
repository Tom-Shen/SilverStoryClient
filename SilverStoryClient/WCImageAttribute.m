//
//  WCImageAttribute.m
//  SilverStoryClient
//
//  Created by Tom Shen on 10/10/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "WCImageAttribute.h"

@implementation WCImageAttribute

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        self.imageSRC = dictionary[@"src"];
    }
    return self;
}

@end
