//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by Rainbow on 16/11/14.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRImageTransformer.h"

@implementation BNRImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }

    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
