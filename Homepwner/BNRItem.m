//
//  BNRItem.m
//  Homepwner
//
//  Created by Rainbow on 16/11/15.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

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


- (void)awakeFromInsert
{
    [super awakeFromInsert];

    self.dateCreated = [NSDate date];

    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

@end
