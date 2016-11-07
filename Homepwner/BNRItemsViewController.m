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
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"

@interface BNRItemsViewController()


@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        /*
        for (int i=0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
         */
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";

        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;

        navItem.leftBarButtonItem = self.editButtonItem;
        self.tableView.rowHeight = 60.0;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    [cell.imageView setImage:item.thumbnail];
    [cell setClipsToBounds:NO];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    // NSInteger lastRow = [[BNRItemStore sharedStore].allItems indexOfObject:newItem];
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    // [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    UINavigationController *navViewController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navViewController animated:YES completion:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailControllder = [[BNRDetailViewController alloc] initForNewItem:NO];

    BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
    detailControllder.item = item;

    [self.navigationController pushViewController:detailControllder animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

@end
