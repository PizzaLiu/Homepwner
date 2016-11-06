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

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
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
    NSString *imgPath = [self imagePathForKey:key];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    [imgData writeToFile:imgPath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *img = [self.dictionary objectForKey:key];
    if (!img) {
        NSString *imgPath = [self imagePathForKey:key];
        img = [UIImage imageWithContentsOfFile:imgPath];
        if (!img) {
            NSLog(@"Unable to find image: %@", key);
        } else {
            [self.dictionary setObject:img forKey:key];
        }
    }

    return  img;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    NSString *imgPath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths firstObject];
    return [docPath stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flush %d images out of the cache.", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

@end
