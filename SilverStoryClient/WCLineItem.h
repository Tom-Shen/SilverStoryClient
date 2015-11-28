//
//  WCLineItem.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/15/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLineItem : NSObject

@property (nonatomic, strong) NSNumber *productID;

@property (nonatomic, strong) NSNumber *lineItemID;

@property (nonatomic, strong) NSNumber *lineItemTotal;

@property (nonatomic, strong) NSNumber *lineNumberQuantity;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
