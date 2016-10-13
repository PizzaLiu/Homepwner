//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Liu on 16/10/13.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property(nonatomic, readonly)NSArray *allItems;

+(instancetype)sharedStore;
-(BNRItem *)createItem;

@end
