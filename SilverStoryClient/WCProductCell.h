//
//  WCProductCell.h
//  SilverStoryClient
//
//  Created by Tom Shen on 10/10/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const WCProductCellIdentifier = @"WCProductCell";

@interface WCProductCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) IBOutlet UILabel *skuLabel;

@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;

@end
