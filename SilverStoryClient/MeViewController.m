//
//  MeViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 10/31/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "MeViewController.h"
#import "WCUser.h"

#import "NSURLSessionDataTask+createDataTask.h"

@interface MeViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avatarSpinnner;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userEmailLabel;
@end

@implementation MeViewController {
    WCUser *currentUser;
    
    NSURLSessionDataTask *dataTask;
    
    NSDictionary *userData;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        currentUser = [[WCUser alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageFinishDownload:) name:WCUserAvatarImageDidFinishDownloadingNotification object:nil];
    }
    return self;
}

- (void)imageFinishDownload:(NSNotification *)notification {
    [self updateUI];
}

- (void)updateUI {
    NSDictionary *customerDict = userData[@"customer"];
    if (userData != nil && customerDict == nil) {
        NSLog(@"Error : Expected customerDict array");
        return;
    }
    
    //self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", customerDict[@"first_name"], customerDict[@"last_name"]];
    self.userNameLabel.text = customerDict[@"username"];
    self.userEmailLabel.text = customerDict[@"email"];
    
    if (currentUser.avatarImage == nil) {
        [currentUser downloadImage:customerDict[@"avatar_url"]];
        [self.avatarSpinnner startAnimating];
    } else {
        self.userAvatarImageView.image = currentUser.avatarImage;
        [self.avatarSpinnner stopAnimating];
    }
    
    currentUser.username = customerDict[@"username"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self clearData];
}

- (void)clearData {
    userData = nil;
    self.userNameLabel.text = @"";
    self.userEmailLabel.text = @"";
    self.userAvatarImageView.image = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
    
    NSLog(@"User ID : %ld", userID);
    
    if (userID < 0) {
        [self performSegueWithIdentifier:@"Login" sender:nil];
        return;
    }
    
    currentUser.userID = [NSNumber numberWithInteger:userID];
    
    if (userData == nil) {
        [self downloadUserData];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadUserData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSInteger userID = [[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"];
    
    NSString *URLPath = USER_CLIENT_URL(userID);
    
    NSString *URLPrefix = [CLIENT_URL stringByAppendingString:URLPath];
    
    NSString *URLSuffix = [NSString stringWithFormat:@"?oauth_consumer_key=%@", CLIENT_CONSUMERS_KEY];
    
    NSString *URLString = [URLPrefix stringByAppendingString:URLSuffix];
    
    NSURL *userURL = [NSURL URLWithString:URLString];
    
    NSLog(@"UserURL : %@", userURL);
    
    dataTask = [NSURLSessionDataTask createNormalDataTaskWithURL:userURL successBlock:^(NSData *data) {
        NSDictionary *dictionary = [self parseJSONFromData:data];
        if (dictionary == nil) {
            NSLog(@"Error : Expected Dictionary");
            [self endDownloadWithSuccess:NO];
        } else {
            userData = dictionary;
            [self endDownloadWithSuccess:YES];
        }
    } failureBlock:^(NSError *error, NSHTTPURLResponse *response) {
        [self endDownloadWithSuccess:NO];
    }];
    [dataTask resume];
}

- (void)endDownloadWithSuccess:(BOOL)success {
    if (!success) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Whoops..." message:@"We have encountered a problem while downloading the user's data." preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"I got it" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self updateUI];
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

- (void)loginViewController:(LoginViewController *)controller didFinishWithUserID:(int)userID {
    NSLog(@"UserID : %d", userID);
    
    currentUser.userID = [NSNumber numberWithInt:userID];
    
    [currentUser saveUserID];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)customerOrderViewControllerDidCancel:(CustomerOrdersViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure" message:@"Are you sure you wants to logout" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self logoutUser:action];
    }];
    [alert addAction:logout];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logoutUser:(id)sender {
    [currentUser deleteUserID];
    
    [self performSegueWithIdentifier:@"Login" sender:sender];
    
    [self clearData];
    
    [currentUser cancelAvatarDownload];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGPoint buttonPoint = self.userNameLabel.center;
    
    NSIndexPath *logoutRowIndexPath = [self.tableView indexPathForRowAtPoint:buttonPoint];
    
    if (indexPath == logoutRowIndexPath) {
        return nil;
    }
    
    return indexPath;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Login"]) {
        LoginViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"ShowOrders"]) {
        UINavigationController *navController = segue.destinationViewController;
        CustomerOrdersViewController *controller = (CustomerOrdersViewController *)navController.topViewController;
        controller.inputUser = currentUser;
        controller.delegate = self;
    }
}

@end
