//
//  WCUser.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/1/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const WCUserAvatarImageDidFinishDownloadingNotification = @"com.tomandjerry.SilverStoryClient.UserAvatarImageDidFinishDownloadingNotification";

@interface WCUser : NSObject

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSNumber *userID;

@property (nonatomic, strong) UIImage *avatarImage;

- (void)saveUserID;

- (void)deleteUserID;

- (void)downloadImage:(NSString *)userAvatarURL;

- (void)cancelAvatarDownload;

@end
