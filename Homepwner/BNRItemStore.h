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
@property(nonatomic, strong)NSMutableArray *allAssetTypes;

+(instancetype)sharedStore;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
-(BOOL)saveItems;
//-(NSArray *)allAssetTypes;

@end
