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

@property(nonatomic,strong)IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    /*
    if (self) {
        for (int i=0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
     */
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    if (indexPath.row >= [items count]) {
        cell.textLabel.text = @"No more items!";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        BNRItem *item = items[indexPath.row];
        cell.textLabel.text = item.description;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [[[BNRItemStore sharedStore] allItems] count]) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView setTableHeaderView:[self headerView]];
}

- (UIView *)headerView
{
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    NSInteger lastRow = [[BNRItemStore sharedStore].allItems indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
}

- (IBAction)toggleEditingMod:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *allItems = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = [allItems objectAtIndex:indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"remove";
}

@end
