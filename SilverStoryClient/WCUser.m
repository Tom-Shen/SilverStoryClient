//
//  WCUser.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/1/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "WCUser.h"

@implementation WCUser {
    NSURLSessionDownloadTask *imageDownloadTask;
}

- (void)registerDefaults {
    NSDictionary<NSString *, id> *defaults = @{@"UserID":@-1};
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)saveUserID {
    [[NSUserDefaults standardUserDefaults] setInteger:self.userID.integerValue forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteUserID {
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerDefaults];
    }
    return self;
}

- (void)downloadImage:(NSString *)userAvatarURL {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *imageURL = [NSURL URLWithString:userAvatarURL];
    
    NSLog(@"ImageURL : %@", imageURL);
    
    NSURLSession *session = [NSURLSession sharedSession];
    imageDownloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error == nil && location != nil) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            if (data != nil) {
                UIImage *image = [UIImage imageWithData:data];
                if (image != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self != nil) {
                            NSLog(@"Finished Downloading Image");
                            self.avatarImage = image;
                            [[NSNotificationCenter defaultCenter] postNotificationName:WCUserAvatarImageDidFinishDownloadingNotification object:nil];
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        }
                    });
                }
            }
        }
    }];
    [imageDownloadTask resume];
}

- (void)dealloc {
    [imageDownloadTask cancel];
}

- (void)cancelAvatarDownload {
    [imageDownloadTask cancel];
}

@end
