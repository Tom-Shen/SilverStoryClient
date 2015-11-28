//
//  WCLineItem.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/15/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "WCLineItem.h"

@implementation WCLineItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.lineItemTotal = dictionary[@"total"];
        self.lineItemID = dictionary[@"id"];
        self.lineNumberQuantity = dictionary[@"quantity"];
        self.productID = dictionary[@"product_id"];
    }
    return self;
}

@end
