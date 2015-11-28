//
//  NSURLSessionDataTask+createDataTask.h
//  SilverStoryClient
//
//  Created by Tom Shen on 11/29/15.
//  Copyright © 2015 Tom and Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionDataTask (createDataTask)

+ (NSURLSessionDataTask *)createNormalDataTaskWithURL:(NSURL *)url successBlock:(void (^)(NSData *returnObject))successBlock failureBlock:(void (^)(NSError *error, NSHTTPURLResponse *response))failureBlock;

+ (NSURLSessionDataTask *)createNormalDataTaskWithRequest:(NSURLRequest *)request successBlock:(void (^)(NSData *returnObject))successBlock failureBlock:(void (^)(NSError *error, NSHTTPURLResponse *response))failureBlock;

@end
