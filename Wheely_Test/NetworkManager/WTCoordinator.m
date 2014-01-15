//
//  WTCoordinator.m
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/10/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import "WTCoordinator.h"
#import "WTNetworkManager.h"
#import "Item.h"

@implementation WTCoordinator

+ (instancetype)sharedCoordinator
{
    static WTCoordinator *sharedObject_ = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject_ = [[self alloc] init];
    });
    
    return sharedObject_;
}

- (void)updateItems:(void(^)(void))handler
{
    
    [[WTNetworkManager sharedNetworkManager] loadItemList:^(id object) {
        
        [self deleteItemFromCoreData:object inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        [object enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSDictionary *objectData = (NSDictionary *)obj;
             
             Item *item = [[Item findByAttribute:@"itemID" withValue:objectData[@"id"]] lastObject];
             if (item)
             {
                 [item MR_importValuesForKeysWithObject:objectData];
             } else
             {
                 [Item MR_importFromObject:objectData inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
             }
             [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
             
         }];
        
    } completionHandlerQueue:dispatch_get_main_queue()];
    
}


- (void)deleteItemFromCoreData:(NSArray *)newObjects inContext:(NSManagedObjectContext *)localContext
{
    
    NSArray *arr = [Item MR_findAll];
    __block BOOL toDelete = NO;
    
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        toDelete = YES;
        Item *existed = obj;
        for (NSDictionary *newObject in newObjects) {
            
            if ([newObject[@"id"] integerValue] == [existed.itemID integerValue])
            {
                toDelete = NO;
            }
        }
        
        if (toDelete)
        {
            [[NSManagedObjectContext MR_contextForCurrentThread] deleteObject:existed];
            [[NSManagedObjectContext MR_contextForCurrentThread]  MR_saveOnlySelfAndWait];
            
        }
        
    }];
}

@end
