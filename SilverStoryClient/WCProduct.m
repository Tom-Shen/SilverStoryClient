//
//  WCProduct.m
//  SilverStoryClient
//
//  Created by Tom Shen on 10/3/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "WCProduct.h"
#import "WCImageAttribute.h"

@implementation WCProduct {
}

- (void)downloadImage {
    NSURL *imageURL = [NSURL URLWithString:((WCImageAttribute *)self.productImages[0]).imageSRC];
    
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
                            self.productThumbnail = image;
                            [[NSNotificationCenter defaultCenter] postNotificationName:WCProductImageFinishDownloadingNotification object:nil];
                        }
                    });
                }
            }
        }
    }];
    [downloadTask resume];
}

- (void)downloadHomeIcon {
    NSURL *imageURL = [NSURL URLWithString:((WCImageAttribute *)self.productImages[0]).imageSRC];
    
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
                            self.productThumbnail = image;
                            [[NSNotificationCenter defaultCenter] postNotificationName:WCHomeProductImageFinishDownloadingNotification object:nil];
                        }
                    });
                }
            }
        }
    }];
    [downloadTask resume];
}

- (void)downloadImageArray {
    for (WCImageAttribute *attribute in self.productImages) {
        NSURL *imageURL = [NSURL URLWithString:attribute.imageSRC];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (error == nil && location != nil) {
                NSData *data = [[NSData alloc] initWithContentsOfURL:location];
                if (data != nil) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self != nil) {
                                if (self.allImages == nil) {
                                    self.allImages = [NSMutableArray arrayWithCapacity:10];
                                }
                                [self.allImages addObject:image];
                                if (self.allImages.count == self.productImages.count) {
                                    NSLog(@"Finished");
                                    [[NSNotificationCenter defaultCenter] postNotificationName:WCProductImageArrayDidFinishNotification object:nil];
                                }
                            }
                        });
                    }
                }
            }
        }];
        [downloadTask resume];
    }
}

@end
