//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Liu on 16/10/13.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore()

@property(nonatomic)NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+(instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;

    /*
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
     */

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
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
    /*
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *itemsArchivePath = [self itemsArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:itemsArchivePath];
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    });
    return self;
}

- (NSArray *)allItems
{
    return _privateItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    [[BNRImageStore sharedStore] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }

    BNRItem *item = [self.privateItems objectAtIndex:fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

# pragma mark - archive


- (NSString *) itemsArchivePath
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths firstObject];
    return [docPath stringByAppendingPathComponent:@"items.data"];
}

- (BOOL)saveItems
{
    NSString *itemsArchivePath = [self itemsArchivePath];

    return [NSKeyedArchiver archiveRootObject:self.allItems toFile:itemsArchivePath];
}

@end
