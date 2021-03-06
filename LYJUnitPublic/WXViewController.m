//
//  WXViewController.m
//  LYJUnitPublic
//
//  Created by yuwang on 2018/6/8.
//  Copyright © 2018年 Aries li. All rights reserved.
//

#import "WXViewController.h"
#import "LYJUnitHeader.h"
#import "NavigationControllerPresentAnimatedTransitioning.h"
#import "NavigationPushAndPopControl.h"

@interface WXViewController () <UIViewControllerTransitioningDelegate>

/** <#message#> */
@property (strong ,nonatomic) NavigationControllerPresentAnimatedTransitioning *transition;

@end

@implementation WXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    button.frame = ({
        CGRect frame  = button.frame;
        frame.origin = CGPointMake(0, 0);
        frame.size = CGSizeMake(22, 22);
        frame;
    });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.interactivePopGestureRecognizer.delegate = [NavigationPushAndPopControl pushAndPopControl];
    [self.navigationController.interactivePopGestureRecognizer addTarget:[NavigationPushAndPopControl pushAndPopControl] action:@selector(popGes:)];
    [NavigationPushAndPopControl setCurrentViewController:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"微信按钮";
}

- (IBAction)WXBtn:(id)sender {
//    [LYJKeyWindowButton showBtnAndPop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [LYJKeyWindowButton pop];
//        [self.navigationController popViewControllerAnimated:YES];
}


@end
