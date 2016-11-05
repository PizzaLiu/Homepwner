//
//  ImagePickerBackgroundView.h
//  Homepwner
//
//  Created by Rainbow on 16/11/5.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerBackgroundView : UIPopoverBackgroundView

{
    CGFloat                     _arrowOffset;
    UIPopoverArrowDirection     _arrowDirection;
    UIImageView                *_arrowImageView;
    UIImageView                *_popoverBackgroundImageView;
}

@property (nonatomic, readwrite)            CGFloat                  arrowOffset;
@property (nonatomic, readwrite)            UIPopoverArrowDirection  arrowDirection;
@property (nonatomic, readwrite, strong)    UIImageView             *arrowImageView;
@property (nonatomic, readwrite, strong)    UIImageView             *popoverBackgroundImageView;

+ (CGFloat)arrowHeight;
+ (CGFloat)arrowBase;
+ (UIEdgeInsets)contentViewInsets;

@end
