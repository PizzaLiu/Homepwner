//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Rainbow on 16/11/8.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView = (UIImageView *)self.view;
    imgView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:nil];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imgView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
