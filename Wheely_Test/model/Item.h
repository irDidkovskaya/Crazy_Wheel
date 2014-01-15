//
//  Item.h
//  Wheely_Test
//
//  Created by Irina Didkovskaya on 1/13/14.
//  Copyright (c) 2014 Irina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * itemText;
@property (nonatomic, retain) NSString * title;

@end
