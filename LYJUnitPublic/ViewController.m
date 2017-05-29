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

    

    
//    data.dictionaryKey(@"哈")
//    .dictionaryFont([UIFont systemFontOfSize:30])
////    .dictionaryUnderline(NSUnderlineStyleSingle)
////    .dictionaryStrikethrough(NSUnderlineStyleSingle)
//    .dictionaryColor([UIColor greenColor])
//    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor yellowColor]);
//    
//    data.dictionaryKey(fullString)
//    .dictionaryFont([UIFont systemFontOfSize:30])
////    .dictionaryUnderline(NSUnderlineStyleSingle)
////    .dictionaryStrikethrough(NSUnderlineStyleSingle)
//    .dictionaryColor([UIColor redColor])
//    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor blueColor]);
//    
//    data.dictionaryKeyAndCount(@"哈", 0)
//    .dictionaryKey(@"我")
//    .dictionaryShadow(CGSizeMake(0, 0), 0, [UIColor clearColor])
//    .dictionaryKern(20);

    
//    data.dictionaryKeyAll(@"哈")
//    .dictionaryColor([UIColor redColor])
//    .dictionaryFont([UIFont systemFontOfSize:30])
//    .dictionaryColor([UIColor redColor])
//    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor blueColor]);
    data.dictionaryKeyAll(@"我")
    .dictionaryColor([UIColor greenColor]);
//    data.dictionaryKeyAll(@"高兴")
//    .dictionaryColor([UIColor blueColor]);
//    data.dictionaryKeyAll(@"人")
//    .dictionaryColor([UIColor yellowColor]);
    
    data.dictionaryKeyRestAll(@"哈")
    .dictionaryColor([UIColor yellowColor])
    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor orangeColor]);
    
    data.dictionaryKeyAndCount(@"高兴", 0)
    .dictionaryColor([UIColor purpleColor]);
    
    self.label.attributedText = [data attributedString];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fullString = @"哈哈我高兴就哈哈要写框架哈哈哈我哈哈哈flilfifly";
    data = [LYJUnitAttributedData dataWithFullText:fullString];
    self.label.text = fullString;
    
    data.dictionaryKey(@"高兴")
    .dictionaryFont([UIFont systemFontOfSize:16])
    .dictionaryColor([UIColor redColor]);
    
    data.dictionaryKeyAll(@"哈")
    .dictionaryColor([UIColor redColor])
    .dictionaryFont([UIFont systemFontOfSize:30])
    .dictionaryColor([UIColor redColor])
    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor blueColor]);
    self.label.attributedText = [data attributedString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
