//
//  ViewController.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "ViewController.h"
#import "LYJUnitAttributedData.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LYJUnitAttributedData *data = [LYJUnitAttributedData dataWithFullText:@"哈哈我高兴就哈哈要写框架哈哈"];
    [data setObject:@"123" forKeyIfNotNil:@"哈哈"];
    [data setObject:@"123" forKeyIfNotNil:@"哈哈"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
