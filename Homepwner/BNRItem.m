//
//  BNRItem.m
//  RandomItems
//
//  Created by Rainbow on 16/10/2.
//  Copyright © 2016年 Rainbow. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeInteger:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _valueInDollars = [aDecoder decodeIntegerForKey:@"valueInDollars"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }

    return self;
}

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

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;

    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);

    // Figure out a acaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);

    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];

    CGRect projectRect;
    projectRect.size.height = image.size.height * ratio;
    projectRect.size.width = image.size.width * ratio;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;

    [image drawInRect:projectRect];

    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    UIGraphicsEndImageContext();
}

@end
