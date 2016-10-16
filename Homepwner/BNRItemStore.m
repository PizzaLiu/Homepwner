//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Liu on 16/10/13.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore()

@property(nonatomic)NSMutableArray *privateItems;
@property(nonatomic)NSMutableArray *privateExpItems;
@property(nonatomic)NSMutableArray *privateChpItems;

@end

@implementation BNRItemStore

+(instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
        _privateExpItems = [[NSMutableArray alloc] init];
        _privateChpItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return _privateItems;
}

- (NSArray *)expItems
{
    return _privateExpItems;
}

- (NSArray *)chpItems
{
    return _privateChpItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    item.valueInDollars > 50 ? [self.privateExpItems addObject:item] : [self.privateChpItems addObject:item];
    return item;
}

@end
