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
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

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
        self.tableView.rowHeight = 65.0;
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
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    if (item.valueInDollars < 50) {
        cell.valueLabel.textColor = [UIColor redColor];
    } else {
        cell.valueLabel.textColor = [UIColor greenColor];
    }
    [cell.thumbnailView setImage:item.thumbnail];
    __weak BNRItemCell *wCell = cell;
    cell.actionBlock = ^{
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            UIImage *image = [[BNRImageStore sharedStore] imageForKey:item.itemKey];
            if (!image) {
                return;
            }
            CGRect rect = wCell.thumbnailView.bounds;
            BNRImageViewController *imvc = [[BNRImageViewController alloc] init];
            imvc.image = image;

            CGSize popSize = CGSizeMake(600, 600);
            CGSize imgSize = image.size;
            float ratio = MIN(popSize.width / imgSize.width, popSize.height / imgSize.height);
            popSize.height = imgSize.height * ratio;
            popSize.width = imgSize.width * ratio;
            // [imvc setPreferredContentSize:CGSizeMake(600, 600)];

            imvc.preferredContentSize = popSize;
            imvc.modalPresentationStyle = UIModalPresentationPopover;
            imvc.popoverPresentationController.sourceView = wCell.thumbnailView;
            imvc.popoverPresentationController.sourceRect = rect;

            [self presentViewController:imvc animated:YES completion:nil];
        }
    };
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
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
