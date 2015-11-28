//
//  LoginViewController.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/1/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "LoginViewController.h"
#import "NSURLSessionDataTask+createDataTask.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController {
    NSURLSessionDataTask *dataTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.usernameTextField becomeFirstResponder];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)login:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8080/wordpress/verify-login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", self.usernameTextField.text, self.passwordTextField.text];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", postData.length];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    dataTask = [NSURLSessionDataTask createNormalDataTaskWithRequest:request successBlock:^(NSData *data) {
        NSDictionary *dictionary = [self parseJSONFromData:data];
        if (dictionary == nil) {
            NSLog(@"Error : Expected Dictionary");
            [self fail];
        } else {
            [self checkLogin:dictionary];
        }
    } failureBlock:^(NSError *error, NSHTTPURLResponse *response) {
        [self fail];
    }];
    [dataTask resume];
}

- (void)dealloc {
    [dataTask cancel];
}

- (void)checkLogin:(NSDictionary *)statusDictionary {
    int statusCode = [[statusDictionary valueForKey:@"status"] intValue];
    if (statusCode == 0) {
        NSLog(@"Error : Password Incorrect");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Username or Password is Incorrect" message:@"Please try again." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        int userID = [[statusDictionary valueForKey:@"userID"] intValue];
        [self.delegate loginViewController:self didFinishWithUserID:userID];
        NSLog(@"Finished");
    }
}

- (void)fail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops..." message:@"There are a problem connecting to the server" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"I got It" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
