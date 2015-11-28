//
//  WCUserOrder.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/8/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "WCUserOrder.h"

@implementation WCUserOrder

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        // Initialization
        self.totalPrice = dictionary[@"total"];
        self.status = dictionary[@"status"];
        self.totalDiscount = dictionary[@"total_discount"];
        self.totalShipping = dictionary[@"total_shipping"];
        self.totalTax = dictionary[@"total_tax"];
        self.totalLineItemsQuantity = dictionary[@"total_line_items_quantity"];
        self.orderID = dictionary[@"id"];
        self.currencyCode = dictionary[@"currency"];
    }
    return self;
}

@end
