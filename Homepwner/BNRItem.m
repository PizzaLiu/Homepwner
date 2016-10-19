//
//  BNRItem.m
//  RandomItems
//
//  Created by Rainbow on 16/10/2.
//  Copyright © 2016年 Rainbow. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+ (instancetype)randomItem
{
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",
                      [randomAdjectiveList objectAtIndex:adjectiveIndex],
                      [randomNounList objectAtIndex:nounIndex]];
    int value = arc4random() % 100;
    NSString *sNum = [NSString stringWithFormat:@"%c%c%c%c%c",
                      '0'+arc4random() % 10,
                      'A'+arc4random() % 26,
                      '0'+arc4random() % 10,
                      'A'+arc4random() % 26,
                      '0'+arc4random() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:name valueInDollars:value serialNumber:sNum];
    return newItem;
}


- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"%@(%@):Worth $%d, recorded on %@",
                      self.itemName,
                      self.serialNumber,
                      self.valueInDollars,
                      self.dateCreated];
    return desc;
}

- (instancetype)initWithItemName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        _itemName = name;
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [self initWithItemName:name];
    if (self) {
        _serialNumber = sNumber;
        _valueInDollars = value;
        _dateCreated = [[NSDate alloc] init];

        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (void)dealloc
{
    NSLog(@"Destroyed:%@", self);
}

@end
