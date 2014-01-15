//
//  WTNetworkManager+Foundation.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTNetworkManager+Foundation.h"

static const NSTimeInterval kTimeoutInterval = 30.0;
static dispatch_queue_t _network_queue;

@interface WTNetworkManager ()
@property dispatch_queue_t network_queue;
@end

@implementation WTNetworkManager (Foundation)


- (NSURLSessionTask *)executeRequestURLString:(NSString *)urlString
                            completionHandler:(BBNetworkManagerResponseHandler)handler
                       completionHandlerQueue:(dispatch_queue_t)queue
{
    
    
    queue = queue ? queue : self.concurentQueue;
    __block NSURLSessionTask *task;
    
    dispatch_async(self.network_queue, ^{
        
        void (^responseHandler)(NSData *, NSHTTPURLResponse *, NSError *) = ^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
            id responseObject = nil;
            
            if (data) {
                
                NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"myString = %@", myString);
                NSError *error;
                responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
                
                dispatch_async(queue, ^{
                    handler(responseObject, error);
                });
            }
        };
        
        
            task = [self createAndProccessGETRequestWithURLString:urlString
                                                completionHandler:responseHandler];
    });
    
    return task;
    
    
}


- (NSURLSessionTask *)createAndProccessGETRequestWithURLString:(NSString *)url
                                             completionHandler:(void (^)(NSData *data, NSHTTPURLResponse *response, NSError *error))handler
{
    NSString *urlString = [url copy];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [self setStandardHTTPHeaderFieldsForRequest:request];
    
    request.timeoutInterval = kTimeoutInterval;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 handler(data, (NSHTTPURLResponse *)response, error);
                                                             }];
    [task resume];
    
    return task;
}

- (void)setStandardHTTPHeaderFieldsForRequest:(NSMutableURLRequest *)request
{
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%i", request.HTTPBody.length] forHTTPHeaderField:@"Content-Length"];
}

- (dispatch_queue_t)network_queue
{
    if (!_network_queue) {
        _network_queue = dispatch_queue_create("com.hata.babbler.network.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _network_queue;
}

@end
