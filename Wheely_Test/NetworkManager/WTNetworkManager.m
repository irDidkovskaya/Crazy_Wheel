//
//  WTNetworkManager.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTNetworkManager.h"
#import "WTNetworkManager+Foundation.h"

#define CRAZY_DEV_LINK @"http://crazy-dev.wheely.com"

@implementation WTNetworkManager

+ (instancetype)sharedNetworkManager
{
    static WTNetworkManager *sharedObject_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject_ = [[self alloc] init];
        sharedObject_.concurentQueue = dispatch_queue_create("com.Wheely_Test.WTNetworkManagerCompletionQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return sharedObject_;
}



- (void)loadItemList:(void (^)(id object))handler completionHandlerQueue:(dispatch_queue_t)queue
{
    [self executeRequestURLString:CRAZY_DEV_LINK completionHandler:^(id object, NSError *error) {
        
        handler(object);
        
    } completionHandlerQueue:queue];

}

@end
