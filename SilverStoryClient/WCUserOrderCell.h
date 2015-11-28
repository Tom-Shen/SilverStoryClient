//
//  WCUserOrderCell.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/8/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const WCUserOrderCellIdentifier = @"WCUserOrderCell";

@interface WCUserOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@end
