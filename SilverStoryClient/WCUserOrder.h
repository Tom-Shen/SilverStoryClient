//
//  WCUserOrder.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/8/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCUserOrder : NSObject

@property (nonatomic, strong) NSString *totalPrice;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSNumber *totalDiscount;

@property (nonatomic, strong) NSNumber *totalLineItemsQuantity;

@property (nonatomic, strong) NSNumber *totalShipping;

@property (nonatomic, strong) NSNumber *totalTax;

@property (nonatomic, strong) NSNumber *orderID;

@property (nonatomic, strong) NSString *currencyCode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)statusToDisplay;

@end
