//
//  WTCoordinator.h
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTCoordinator : NSObject
+ (instancetype)sharedCoordinator;
- (void)updateItems:(void(^)(void))handler;
@end
