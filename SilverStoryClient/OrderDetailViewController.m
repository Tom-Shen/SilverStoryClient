//
//  OrderDetailViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/28/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderIDLabel.text = self.inputOrder.orderID.stringValue;
    self.statusLabel.text = [self.inputOrder statusToDisplay];
    
    self.subtotalLabel.text = [self.inputOrder formatSubtotal];
    
    NSDate *createdDate = [self formatDateString:self.inputOrder.createdDate];
    self.createdDateLabel.text = [self formatDate:createdDate];
}

- (NSDate *)formatDateString:(NSString *)string {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    return [formatter dateFromString:string];
}

- (NSString *)formatDate:(NSDate *)date {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return [formatter stringFromDate:date];
}

- (IBAction)close:(id)sender {
    [self.delegate orderDetailViewControllerCloseButtonClicked:self];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return nil;
        case 2: return nil;
        case 3: return nil;
        case 4: return nil;
        case 5: return nil;
        case 6: return nil;
        case 8: return nil;
        default: return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 7 && indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.inputOrder.viewOrderURL]];
        
        NSLog(@"%@", self.inputOrder.viewOrderURL);
    }
}

@end
