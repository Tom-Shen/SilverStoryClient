//
//  CustomerOrdersViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/7/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "CustomerOrdersViewController.h"
#import "WCUserOrder.h"
#import "WCUserOrderCell.h"

#import "NSURLSessionDataTask+createDataTask.h"

@interface CustomerOrdersViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CustomerOrdersViewController {
    NSURLSessionDataTask *dataTask;
    
    NSMutableArray *allOrders;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization
        allOrders = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self downloadOrderData];
    
    UINib *cellNib = [UINib nibWithNibName:WCUserOrderCellIdentifier bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:WCUserOrderCellIdentifier];
}

- (NSDictionary *)parseJSONFromData:(NSData *)data {
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"JSON Error : %@", error);
        return nil;
    }
    
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"JSON Error : Expected Dictionary");
        return nil;
    }
    
    return JSONObject;
}

- (void)downloadOrderData {
    NSString *URLPath = [USER_CLIENT_URL(self.inputUser.userID.integerValue) stringByAppendingString:@"/orders"];
    NSString *URLPrefix = [CLIENT_URL stringByAppendingString:URLPath];
    NSString *URLSuffix = [NSString stringWithFormat:@"?oauth_consumer_key=%@", CLIENT_CONSUMERS_KEY];
    NSString *URLString = [URLPrefix stringByAppendingString:URLSuffix];
    NSURL *dataURL = [NSURL URLWithString:URLString];
    
    NSLog(@"dataURL : %@", dataURL);
    
    // NSURLSession *session = [NSURLSession sharedSession];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
    dataTask = [NSURLSessionDataTask createNormalDataTaskWithURL:dataURL successBlock:^(NSData *data) {
        NSDictionary *dictionary = [self parseJSONFromData:data];
        if (dictionary == nil) {
            NSLog(@"Error : Expected Dictionary");
            [self endDownloadWithSuccess:NO];
        } else {
            [self parseDictionary:dictionary];
        }
    } failureBlock:^(NSError *error, NSHTTPURLResponse *response) {
        [self endDownloadWithSuccess:NO];
    }];
    [dataTask resume];
}

- (void)dealloc {
    [dataTask cancel];
}

- (void)endDownloadWithSuccess:(BOOL)success {
    if (!success) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops..." message:@"We have encountered a problem while retriving the user data" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"I got it" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.tableView reloadData];
}

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *orders = dictionary[@"orders"];
    if (orders == nil) {
        NSLog(@"Error : Expected 'orders' array");
        [self endDownloadWithSuccess:NO];
        return;
    }
    
    // NSLog(@"Orders : %@", orders);
    
    for (NSDictionary *orderDict in orders) {
        WCUserOrder *userOrder = [[WCUserOrder alloc] initWithDictionary:orderDict];
        [allOrders addObject:userOrder];
    }
    
    [self endDownloadWithSuccess:YES];
}

- (NSString *)formatPrice:(NSNumber *)price currencyCode:(NSString *)currencyCode {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:currencyCode];
    return [formatter stringFromNumber:price];
}

- (IBAction)close:(id)sender {
    [self.delegate customerOrderViewControllerDidCancel:self];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allOrders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WCUserOrderCellIdentifier];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WCUserOrderCell *orderCell = (WCUserOrderCell *)cell;
    
    WCUserOrder *order = allOrders[indexPath.row];
    
    orderCell.discountLabel.text = [NSString stringWithFormat:@"Discount:%@", order.totalDiscount];
    orderCell.totalTaxLabel.text = [NSString stringWithFormat:@"Tax:%@", order.totalTax];
    orderCell.statusLabel.text = [order statusToDisplay];
    orderCell.orderIDLabel.text = [NSString stringWithFormat:@"ID %@", order.orderID];
    
    NSString *formattedPrice = [self formatPrice:[NSNumber numberWithFloat:order.totalPrice.intValue] currencyCode:order.currencyCode];
    orderCell.totalPriceLabel.text = formattedPrice;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"ShowOrderDetail" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowOrderDetail"]) {
        UINavigationController *navController = segue.destinationViewController;
        OrderDetailViewController *controller = (OrderDetailViewController *)navController.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        WCUserOrder *order = allOrders[indexPath.row];
        
        controller.inputOrder = order;
    }
}

- (void)orderDetailViewControllerCloseButtonClicked:(OrderDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
