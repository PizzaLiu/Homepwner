//
//  BNRItem.h
//  Homepwner
//
//  Created by Rainbow on 16/11/15.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

-(void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
