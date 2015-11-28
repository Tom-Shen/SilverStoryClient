//
//  WCCategory.m
//  SilverStoryClient
//
//  Created by Tom Shen on 9/29/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "WCCategory.h"

@implementation WCCategory

- (void)downloadImage {
    NSURL *imageURL = [NSURL URLWithString:self.categoryImageURL];;
    if (imageURL == nil) {
        // No Image
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error == nil && location != nil) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            if (data != nil) {
                UIImage *image = [UIImage imageWithData:data];
                if (image != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self != nil) {
                            NSLog(@"Finished Downloading Image");
                            self.categotyImage = image;
                            [[NSNotificationCenter defaultCenter] postNotificationName:WCCategoryImageFinishDownloadingNotification object:nil];
                        }
                    });
                }
            }
        }
    }];
    [downloadTask resume];
}

- (NSComparisonResult)compareName:(WCCategory *)other {
    return [self.categoryName localizedStandardCompare:other.categoryName];
}

@end
