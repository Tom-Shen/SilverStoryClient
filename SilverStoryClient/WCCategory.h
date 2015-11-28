//
//  WCCategory.h
//  SilverStoryClient
//
//  Created by Tom Shen on 9/29/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CategoryViewController.h"

static NSString * const WCCategoryImageFinishDownloadingNotification = @"com.tomandjerry.SilverStoryClient.ImageFinishDownloadingNotification";

@interface WCCategory : NSObject 

@property (nonatomic) NSNumber *categoryId;
@property (nonatomic) NSString *categoryName;
@property (nonatomic) NSString *categorySlug;
@property (nonatomic) NSString *categoryDescription;
@property (nonatomic) NSString *categoryDisplay;
@property (nonatomic) NSString *categoryImageURL;
@property (nonatomic) UIImage *categotyImage;
@property (nonatomic) NSNumber *categoryItemsCount;
@property (nonatomic) NSNumber *categoryParentId;

- (void)downloadImage;

- (NSComparisonResult)compareName:(WCCategory *)other;

@end
