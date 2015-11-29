//
//  OrderDetailViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/28/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderIDLabel.text = self.inputOrder.orderID.stringValue;
    self.statusLabel.text = [self.inputOrder statusToDisplay];
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
}

@end
