//
//  BNRChangeCreatedDateViewController.m
//  Homepwner
//
//  Created by Rainbow on 16/10/19.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRChangeCreatedDateViewController.h"
#import "BNRItem.h"

@interface BNRChangeCreatedDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation BNRChangeCreatedDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datePicker setDate:self.item.dateCreated];
}

- (IBAction)doneWithDatePicker:(id)sender
{
    NSDate *newDate = self.datePicker.date;
    self.item.dateCreated = newDate;

    [self.navigationController popViewControllerAnimated:YES];
}

@end
