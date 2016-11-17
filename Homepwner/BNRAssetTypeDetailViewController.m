//
//  BNRAssetTypeDetailViewController.m
//  Homepwner
//
//  Created by Rainbow on 16/11/17.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRAssetTypeDetailViewController.h"
#import "BNRItemStore.h"

@interface BNRAssetTypeDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *labelTextField;

@end

@implementation BNRAssetTypeDetailViewController

- (instancetype)init
{
    return [super initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)cancel:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)done:(id)sender
{
    if (!self.labelTextField.text) {
        return ;
    }
    [self setEditing:NO];

    [[BNRItemStore sharedStore] addAssetType:self.labelTextField.text];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
    } else {
        self.dismissBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
