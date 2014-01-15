//
//  WTNetworkManager+Foundation.h
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTNetworkManager.h"

typedef void(^BBNetworkManagerResponseHandler)(id object, NSError *error);
@interface WTNetworkManager (Foundation)

- (NSURLSessionTask *)executeRequestURLString:(NSString *)urlString
                            completionHandler:(BBNetworkManagerResponseHandler)handler
                       completionHandlerQueue:(dispatch_queue_t)queue;
@end
