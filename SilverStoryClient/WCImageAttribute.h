//
//  WCImageAttribute.h
//  SilverStoryClient
//
//  Created by Tom Shen on 10/10/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCImageAttribute : NSObject

@property (nonatomic, strong) NSNumber *imageId;

@property (nonatomic, strong) NSString *imageCreateAt;

@property (nonatomic, strong) NSString *imageUpdatedAt;

@property (nonatomic, strong) NSString *imageSRC; // Required

@property (nonatomic, strong) NSString *imageTitle;

@property (nonatomic, strong) NSString *imageALT;

@property (nonatomic, strong) NSNumber *imagePosition;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
