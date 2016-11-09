//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Rainbow on 16/11/7.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (void)awakeFromNib {
    [self updateInterfaceForDynamicType];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(updateInterfaceForDynamicType) name:UIContentSizeCategoryDidChangeNotification object:nil];

    NSLayoutConstraint *thumbnailConstraint = [NSLayoutConstraint
                                               constraintWithItem:self.thumbnailView
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self.thumbnailView
                                               attribute:NSLayoutAttributeWidth
                                               multiplier:1.0
                                               constant:0.0];
    [self.thumbnailView addConstraint:thumbnailConstraint];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)updateInterfaceForDynamicType
{
    UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFont *bodyFontSmall = [bodyFont fontWithSize:(bodyFont.pointSize * 0.75)];

    self.nameLabel.font = bodyFont;
    self.serialNumberLabel.font = bodyFontSmall;
    self.valueLabel.font = bodyFont;

    // for thumbnail
    static NSDictionary *thumbnailSizeDictionary;

    if (!thumbnailSizeDictionary) {
        thumbnailSizeDictionary = @{
                                 @"UICTContentSizeCategoryXS": @40,
                                 @"UICTContentSizeCategoryS": @40,
                                 @"UICTContentSizeCategoryM":@40,
                                 @"UICTContentSizeCategoryL":@40,
                                 @"UICTContentSizeCategoryXL":@40,
                                 @"UICTContentSizeCategoryXXL":@50,
                                 @"UICTContentSizeCategoryXXXL":@50,
                                 @"UICTContentSizeCategoryAccessibilityM":@50,
                                 @"UICTContentSizeCategoryAccessibilityL":@55,
                                 @"UICTContentSizeCategoryAccessibilityXL":@65,
                                 @"UICTContentSizeCategoryAccessibilityXXL":@75,
                                 @"UICTContentSizeCategoryAccessibilityXXXL":@85
                                 };
    }

    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *thumbnailSize = thumbnailSizeDictionary[userSize];
    self.thumbnailHeightConstraint.constant = thumbnailSize.floatValue;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter removeObserver:self];
}


@end
