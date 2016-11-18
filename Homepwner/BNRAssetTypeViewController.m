//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by Rainbow on 16/11/17.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeDetailViewController.h"

@interface BNRAssetTypeViewController ()

@end

@implementation BNRAssetTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.clearsSelectionOnViewWillAppear = NO;

    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addType:)];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (NSArray *)getRelativeItems
{
    return [self.item.assetType valueForKey:@"items"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.item.assetType) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[[BNRItemStore sharedStore] allAssetTypes] count];
    }

    return [[self getRelativeItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        NSArray *allTypes = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = allTypes[indexPath.row];
        NSString *assetLabel = [assetType valueForKey:@"label"];

        cell.textLabel.text = assetLabel;

        if (assetType == self.item.assetType) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        NSArray *items = [self getRelativeItems];
        BNRItem *item = [items objectAtIndex:indexPath.row];

        /*
        NSArray *allItems = [[BNRItemStore sharedStore] allItems];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"AssetType == %@", self.item.assetType];
        NSArray *typeItems = [allItems filteredArrayUsingPredicate:p];

        BNRItem *item = typeItems[indexPath.row];
         */

        cell.textLabel.text = item.itemName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return;
    }
    NSArray *allTypes = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allTypes[indexPath.row];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    self.item.assetType = assetType;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"All Types";
    }

    return [NSString stringWithFormat:@"All Items of Label: %@", [self.item.assetType valueForKey:@"label"] ];
}

#pragma mark - edit

- (void)addType:(id)sender
{
    BNRAssetTypeDetailViewController *atdvc = [[BNRAssetTypeDetailViewController alloc] init];
    atdvc.dismissBlock = ^{
        [self.tableView reloadData];
    };

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:atdvc];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:navController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:atdvc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *allAssetTypes = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = [allAssetTypes objectAtIndex:indexPath.row];
        [[BNRItemStore sharedStore] removeAssetType:assetType];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
