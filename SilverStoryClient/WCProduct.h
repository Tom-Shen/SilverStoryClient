//
//  WCProduct.h
//  SilverStoryClient
//
//  Created by Tom Shen on 10/3/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const WCProductNothingFoundCellIdentifier = @"WCProductNothingFoundCell";

static NSString * const WCProductImageFinishDownloadingNotification = @"com.tomandjerry.SilverStoryClient.ProductImageFinishDownloadingNotification";

static NSString * const WCHomeProductImageFinishDownloadingNotification = @"com.tomandjerry.SilverStoryClient.HomeProductImageFinishDownloadingNotification";

static NSString * const WCProductImageArrayDidFinishNotification = @"com.tomandjerry.SilverStoryClient.ProductImageArrayFinishDownloadingNotification";

@interface WCProduct : NSObject

@property (nonatomic, strong) NSString *productTitle; // Required

@property (nonatomic, strong) NSNumber *productId; // System Required

@property (nonatomic, strong) NSString *productCreateTime;

@property (nonatomic, strong) NSString *productUpdateTime;

@property (nonatomic, strong) NSString *productType; // Required

@property (nonatomic, strong) NSString *productStatus;

@property (nonatomic, strong) NSString *productParmalink;

@property (nonatomic, strong) NSString *productSKU; // Required

@property (nonatomic, strong) NSDecimalNumber *productPrice; // Required

@property (nonatomic, strong) NSDecimalNumber *productRegularPrice; // Required

@property (nonatomic, strong) NSDecimalNumber *productSalePrice; // Required

@property (nonatomic, strong) NSDecimalNumber *productSalePriceDatesFrom;

@property (nonatomic, strong) NSDecimalNumber *productSalePriceDateTo;

@property (nonatomic, strong) NSString *productPriceHTML;

@property (nonatomic, strong) NSNumber *productTaxable;

@property (nonatomic, strong) NSString *productTaxStatus;

@property (nonatomic, strong) NSString *productTaxClass;

@property (nonatomic, strong) NSNumber *productStockQuantity;

@property (nonatomic, strong) NSNumber *productInStock;

@property (nonatomic, strong) NSNumber *productPurchasable;

@property (nonatomic, strong) NSNumber *productFeatured;

@property (nonatomic, strong) NSNumber *productVisible;

@property (nonatomic, strong) NSString *productCatalogVisibility;

@property (nonatomic, strong) NSNumber *productOnSale;

@property (nonatomic, strong) NSString *productWeight;

@property (nonatomic, strong) NSArray *productDimensions;

@property (nonatomic, strong) NSNumber *productShippingRequired;

@property (nonatomic, strong) NSNumber *productShippingTaxable;

@property (nonatomic, strong) NSString *productShippingClass;

@property (nonatomic, strong) NSNumber *productShippingClassID;

@property (nonatomic, strong) NSString *productDescription;

@property (nonatomic, strong) NSNumber *productEnableHTMLDescription;

@property (nonatomic, strong) NSString *productShortDescription;

@property (nonatomic, strong) NSString *productEnableHTMLShortDescription;

@property (nonatomic, strong) NSNumber *productReviewsAllowed;

@property (nonatomic, strong) NSString *productAverageRating;

@property (nonatomic, strong) NSNumber *productRatingCount;

@property (nonatomic, strong) NSArray *productRelatedIDs;

@property (nonatomic, strong) NSNumber *productParentID;

@property (nonatomic, strong) NSArray *productCategories; // Required

@property (nonatomic, strong) NSArray *productTags;

@property (nonatomic, strong) NSArray *productImages; // Required

@property (nonatomic, strong) NSString *productFeaturedSRC;

@property (nonatomic, strong) NSArray *productAttributes;

@property (nonatomic, strong) NSArray *productDefaultAttributes;

@property (nonatomic, strong) NSArray *productDownloads;

@property (nonatomic, strong) NSNumber *productDownloadLimit;

@property (nonatomic, strong) NSNumber *productDownloadExpiry;

@property (nonatomic, strong) NSString *productDownloadType;

@property (nonatomic, strong) NSString *productPurchaseNote;

@property (nonatomic, strong) NSNumber *productTotalSales;

@property (nonatomic, strong) NSArray *productVariations;

@property (nonatomic, strong) NSString *productURL;

@property (nonatomic, strong) NSString *productImageURL;

@property (nonatomic, strong) UIImage *productThumbnail;

@property (nonatomic, strong) NSMutableArray *allImages;

- (void)downloadImage;

- (void)downloadHomeIcon;

- (void)downloadImageArray;

@end
