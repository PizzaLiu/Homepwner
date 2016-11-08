//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by Rainbow on 16/11/8.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.imageView setCenter:CGPointMake(600/2, 600/2)];
    // UIImageView *imgView = self.imageView;
    // imgView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    CGSize size = self.preferredContentSize;

    self.imageView = [[UIImageView alloc] initWithImage:self.image];

    CGRect frame = self.imageView.frame;
    frame.size = size;


    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = frame;
    self.imageView.center = CGPointMake(size.width/2, size.height/2);

    UIScrollView *scrollView = [[UIScrollView alloc] init];

    scrollView.contentSize = CGSizeMake(size.width, size.height);
    scrollView.pagingEnabled = NO;
    scrollView.scrollEnabled = NO;
    scrollView.zoomScale = 1.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 5.0;
    scrollView.delegate = self;

    [scrollView addSubview:self.imageView];

    self.view = scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //[self.imageView setCenter:CGPointMake(600/2, 600/2)];
    return self.imageView;
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
