//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Rainbow on 16/10/18.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController <UIViewControllerRestoration>

@property(nonatomic, strong) BNRItem *item;
@property(nonatomic, copy) void (^dismissBlock)(void);

- (instancetype) initForNewItem:(BOOL)isNewItem;

@end
