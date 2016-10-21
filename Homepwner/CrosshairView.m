//
//  CrosshairView.m
//  Homepwner
//
//  Created by Rainbow on 16/10/19.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "CrosshairView.h"

@implementation CrosshairView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self setCrossHairColor:[UIColor colorWithRed:8 green:8 blue:8 alpha:.7]];
        [self setCrossHairLineWidth:2.0];
        [self setCrossHairLineLength:40.0];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0 + 10;

    CGPoint verBegin, verEnd;
    verBegin.x = center.x - self.crossHairLineLength / 2.0;
    verBegin.y = center.y;
    verEnd.x = center.x + self.crossHairLineLength / 2.0;
    verEnd.y = center.y;

    CGPoint horBegin, horEnd;
    horBegin.x = center.x;
    horBegin.y = center.y - self.crossHairLineLength / 2.0;
    horEnd.x = center.x;
    horEnd.y = center.y + self.crossHairLineLength / 2.0;


    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = self.crossHairLineWidth;
    [[UIColor lightGrayColor] setStroke];

    [path moveToPoint:verBegin];
    [path addLineToPoint:verEnd];
    [path stroke];

    [path moveToPoint:horBegin];
    [path addLineToPoint:horEnd];
    [path stroke];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}


@end