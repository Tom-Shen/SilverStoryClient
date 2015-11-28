//
//  NSURLSessionDataTask+createDataTask.m
//  SilverStoryClient
//
//  Created by Tom Shen on 11/29/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import "NSURLSessionDataTask+createDataTask.h"

@implementation NSURLSessionDataTask (createDataTask)

+ (NSURLSessionDataTask *)createNormalDataTaskWithURL:(NSURL *)url successBlock:(void (^)(NSData *))successBlock failureBlock:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock {
    NSURLSessionDataTask *dataTask;
    
    dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error) {
            NSLog(@"Error : %@", error);
            dispatch_async(mainQueue, ^{
                failureBlock(error, nil);
            });
        } else if (httpResponse != nil) {
            if (httpResponse.statusCode == 200) {
                dispatch_async(mainQueue, ^{
                    successBlock(data);
                });
            } else {
                NSLog(@"Error : HTTP Status Code is not 200 : %@", httpResponse);
                dispatch_async(mainQueue, ^{
                    failureBlock(nil, httpResponse);
                });
            }
        } else {
            NSLog(@"Unknown Error");
            dispatch_async(mainQueue, ^{
                failureBlock(nil, nil);
            });
        }
    }];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)createNormalDataTaskWithRequest:(NSURLRequest *)request successBlock:(void (^)(NSData *))successBlock failureBlock:(void (^)(NSError *, NSHTTPURLResponse *))failureBlock {
    NSURLSessionDataTask *dataTask;
    
    dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error) {
            NSLog(@"Error : %@", error);
            dispatch_async(mainQueue, ^{
                failureBlock(error, nil);
            });
        } else if (httpResponse != nil) {
            if (httpResponse.statusCode == 200) {
                dispatch_async(mainQueue, ^{
                    successBlock(data);
                });
            } else {
                NSLog(@"Error : HTTP Status Code is not 200 : %@", httpResponse);
                dispatch_async(mainQueue, ^{
                    failureBlock(nil, httpResponse);
                });
            }
        } else {
            NSLog(@"Unknown Error");
            dispatch_async(mainQueue, ^{
                failureBlock(nil, nil);
            });
        }
    }];
    
    return dataTask;
}

@end
