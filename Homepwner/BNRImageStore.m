//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Rainbow on 16/10/19.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore()

@property(nonatomic, strong)NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

+ (instancetype)sharedStore
{
    static BNRImageStore *shareStore = nil;

    if (!shareStore) {
        shareStore = [[BNRImageStore alloc] initPrivate];
    }

    return shareStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (!_dictionary) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRImageStore shareStore]" userInfo:nil];
    return nil;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [self.dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
