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
    
//    data
//    .key(@"")
//    .object()
//    .lineOffset()
//    .kern();
    [data setObject:[UIColor blueColor] forKeyIfNotNil:fullString andDataType:LYJAttributedDataTypeColor];
    [data setObject:[UIFont systemFontOfSize:30] forAllKeyIfNotNil:@"我" andDataType:LYJAttributedDataTypeFont];
    [data setObject:[UIColor brownColor] forAllKeyIfNotNil:@"我" andDataType:LYJAttributedDataTypeColor];
    [data setObject:@5 forAllKeyIfNotNil:@"哈" andDataType:LYJAttributedDataTypeKern];
    [data setObject:@5 forAllKeyIfNotNil:@"哈" andDataType:LYJAttributedDataTypeLineOffset];
    [data setObject:[UIFont systemFontOfSize:10] forAllKeyIfNotNil:@"哈" andDataType:LYJAttributedDataTypeFont];
    [data setObject:[UIColor redColor] forAllKeyIfNotNil:@"哈" andDataType:LYJAttributedDataTypeColor];

    self.label.attributedText = [data attributedString];
    
    NSArray *items = [data allObjectOrNilForKey:@"哈"];
    NSLog(@"%@",items);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
