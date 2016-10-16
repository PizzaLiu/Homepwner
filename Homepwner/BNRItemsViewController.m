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
    return [items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *items = [self getSectionItems:indexPath.section];
    BNRItem *item = items[indexPath.row];
    
    cell.textLabel.text = item.description;
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
