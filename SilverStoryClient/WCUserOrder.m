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
        self.viewOrderURL = dictionary[@"view_order_url"];
        self.createdDate = dictionary[@"created_at"];
    }
    return self;
}

- (NSString *)statusToDisplay {
    if ([self.status isEqualToString:@"pending"]) {
        return @"Pending";
    } else if ([self.status isEqualToString:@"processing"]) {
        return @"Processing";
    } else if ([self.status isEqualToString:@"on-hold"]) {
        return @"On Hold";
    } else if ([self.status isEqualToString:@"completed"]) {
        return @"Completed";
    } else if ([self.status isEqualToString:@"cancelled"]) {
        return @"Cancelled";
    } else if ([self.status isEqualToString:@"refunded"]) {
        return @"Refunded";
    } else if ([self.status isEqualToString:@"failed"]) {
        return @"Failed";
    } else {
        return self.status;
    }
}

@end
