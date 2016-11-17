//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by Rainbow on 16/11/17.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItemStore.h"

@interface BNRAssetTypeViewController ()

@end

@implementation BNRAssetTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];

    NSArray *allTypes = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allTypes[indexPath.row];
    NSString *assetLabel = [assetType valueForKey:@"label"];

    cell.textLabel.text = assetLabel;

    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allTypes = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allTypes[indexPath.row];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    self.item.assetType = assetType;

    [self.navigationController popViewControllerAnimated:YES];
}

@end
