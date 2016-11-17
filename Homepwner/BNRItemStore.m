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
@property(nonatomic, strong)NSManagedObjectModel *model;
@property(nonatomic, strong)NSManagedObjectContext *context;

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
        /*
        NSString *itemsArchivePath = [self itemsArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:itemsArchivePath];
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
         */
        // read in .xcdatamodeld file
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];

        // get the SQLite file path
        NSString *path = [self itemsArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];

        NSError *error = nil;

        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }

        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;

        [self loadAllItems];
    });
    return self;
}

- (NSArray *)allItems
{
    return _privateItems;
}

- (BNRItem *)createItem
{
    /*
    BNRItem *item = [[BNRItem alloc] init];//[BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
     */
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);

    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:self.context];
    item.orderingValue = order;
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    [[BNRImageStore sharedStore] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
    [self.context deleteObject:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }

    BNRItem *item = [self.privateItems objectAtIndex:fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];

    double lowerBound = 0.0;
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }

    double upperBound = 0.0;
    if (toIndex < ([self.privateItems count] - 1)) {
        upperBound = [self.privateItems[toIndex + 1] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }

    double newOrderingValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"Moving item to %.2f", newOrderingValue);
    item.orderingValue = newOrderingValue;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        request.entity = e;

        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];

        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }

        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

# pragma mark - archive


- (NSString *) itemsArchivePath
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths firstObject];
    return [docPath stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveItems
{
    NSError *error;
    BOOL successful = [self.context save:&error];

    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }

    return successful;
}

# pragma mark - assetType

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:self.context];
        request.entity = e;

        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }

    if ([_allAssetTypes count] == 0) {
        [self addAssetType:@"Furniture"];
        [self addAssetType:@"Jewelry"];
        [self addAssetType:@"Electronics"];
    }

    return _allAssetTypes;
}

- (void)addAssetType:(NSString *)label
{
    NSManagedObject *type;

    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    [type setValue:label forKey:@"label"];
    [_allAssetTypes addObject:type];
}

- (void)removeAssetType:(NSManagedObject *)assetType
{
    NSLog(@"Remove~");
    [self.allAssetTypes removeObjectIdenticalTo:assetType];

    [self.context deleteObject:assetType];
}

@end
