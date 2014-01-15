//
//  WTNetworkManager.h
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNetworkManager : NSObject

@property (strong) dispatch_queue_t concurentQueue;

+ (instancetype)sharedNetworkManager;
- (void)loadItemList:(void (^)(id object))handler completionHandlerQueue:(dispatch_queue_t)queue;



@end
