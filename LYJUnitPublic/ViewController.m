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

    
    data.dictionaryKey(@"")
    .dictionaryFont([UIFont systemFontOfSize:30])
    //    .dictionaryUnderline(NSUnderlineStyleSingle)
    //    .dictionaryStrikethrough(NSUnderlineStyleSingle)
    .dictionaryColor([UIColor greenColor])
    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor yellowColor])
    .dictionaryCount(0);
    
    data.dictionaryKey(@"哈")
    .dictionaryFont([UIFont systemFontOfSize:30])
//    .dictionaryUnderline(NSUnderlineStyleSingle)
//    .dictionaryStrikethrough(NSUnderlineStyleSingle)
    .dictionaryColor([UIColor greenColor])
    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor yellowColor]);
    
    data.dictionaryKey(fullString)
    .dictionaryFont([UIFont systemFontOfSize:30])
//    .dictionaryUnderline(NSUnderlineStyleSingle)
//    .dictionaryStrikethrough(NSUnderlineStyleSingle)
    .dictionaryColor([UIColor redColor])
    .dictionaryShadow(CGSizeMake(2, 3), 5, [UIColor blueColor]);
    
    
    
    
    self.label.attributedText = [data attributedString];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fullString = @"哈哈我高兴就哈哈要写框架哈哈哈我哈哈哈flilfifly";
    data = [LYJUnitAttributedData dataWithFullText:fullString];
    self.label.text = fullString;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
