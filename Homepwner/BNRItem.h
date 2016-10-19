//
//  BNRItem.h
//  RandomItems
//
//  Created by Rainbow on 16/10/2.
//  Copyright © 2016年 Rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject


@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate *dateCreated;


+(instancetype)randomItem;

-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;


@end
