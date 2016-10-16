//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Liu on 16/10/12.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@interface BNRItemsViewController()

@property(nonatomic)NSArray *expItems;
@property(nonatomic)NSArray *chpItems;

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    NSPredicate *expPredicate = [NSPredicate predicateWithFormat:@"valueInDollars >= 50"];
    NSPredicate *chpPredicate = [NSPredicate predicateWithFormat:@"valueInDollars < 50"];
    if (self) {
        for (int i=0; i < 35; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    _expItems = [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:expPredicate];
    _chpItems = [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:chpPredicate];
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = [self getSectionItems:section];
    NSInteger count = [items count];
    if (section >= (tableView.numberOfSections - 1)) {
        count ++;
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section >= (tableView.numberOfSections - 1)) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"No more items!";
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;

        return label;
    }
    return nil;
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *items = [self getSectionItems:indexPath.section];
    if (indexPath.section >= (tableView.numberOfSections - 1) && indexPath.row >= [items count]) {
        cell.textLabel.text = @"No more items!";
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        BNRItem *item = items[indexPath.row];
        cell.textLabel.text = item.description;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"More than $50";
    }
    return @"Else";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSArray *)getSectionItems:(NSInteger)section
{
    if (section == 0) {
        return [self expItems];
    }
    return [self chpItems];
}

@end
