//
//  BNRAssetTypeViewController.h
//  Homepwner
//
//  Created by Rainbow on 16/11/17.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"

@interface BNRAssetTypeViewController : UITableViewController

@property(nonatomic, weak) BNRItem *item;
@property(nonatomic, copy) void(^dismissBlock)(void);

@end
