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
{
    LYJUnitAttributedData *data;
    NSString *fullString;
}
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController
- (IBAction)tap:(id)sender {
    LYJUnitAttributedDictionary *dictionary = [[data objectOrNilForKey:@"哈哈" andDataType:LYJAttributedDataTypeKern] firstObject];
//    dictionary.object = @0;
    
//    [data changeValueWithDictionary:dictionary object:[UIColor redColor] andDataType:LYJAttributedDataTypeColor];
//    [data changeValueWithDictionary:dictionary andCount:6];
    
    
//    self.label.attributedText = [data attributedString];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fullString = @"哈哈我高兴就哈哈要写框架哈哈哈我哈哈哈";
    data = [LYJUnitAttributedData dataWithFullText:fullString];
    [data setObject:[UIColor blueColor] forKeyIfNotNil:fullString andDataType:LYJAttributedDataTypeColor];
    [data setObject:[UIFont systemFontOfSize:20] forAllKeyIfNotNil:@"我" andDataType:LYJAttributedDataTypeFont];
    [data setObject:@20 forAllKeyIfNotNil:@"我" andDataType:LYJAttributedDataTypeKern];
    [data setObject:@20 forKeyIfNotNil:@"哈哈" andDataType:LYJAttributedDataTypeKern];
//    [data setObject:[UIColor redColor] forAllKeyIfNotNil:@"我" andDataType:LYJAttributedDataTypeColor];
//    [data setObject:[UIColor grayColor] forKeyIfNotNil:@"哈哈" andDataType:LYJAttributedDataTypeColor];
//    [data setObject:[UIColor greenColor] forKeyIfNotNil:@"哈哈" andDataType:LYJAttributedDataTypeColor];
    self.label.attributedText = [data attributedString];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
