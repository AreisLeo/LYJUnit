//
//  ViewController.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "ViewController.h"
#import "LYJUnitAttributedData.h"
#import "LYJUnit.h"
@interface ViewController ()
{
    NSString *fullString;
}
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController
- (IBAction)tap:(id)sender {


    self.label.attributedText = [LYJUnit _attributedStringWithFullText:fullString andAttributedData:^(LYJUnitAttributedData *attributedData) {
        attributedData.dictionaryKeyAll(@"哈哈")
        .dictionaryColor([UIColor redColor])
        .dictionaryFont([UIFont systemFontOfSize:20])
        .dictionaryStrokeWidth(5);
        attributedData.dictionaryKeyAll(@"我")
        .dictionaryColor([UIColor blueColor])
        .dictionaryFont([UIFont systemFontOfSize:25])
        .dictionaryStrokeWidth(5);
    }];
    
}
- (IBAction)localNotificationSend:(id)sender
{
    [LYJUnit _localNotificationWithAlertBody:@"哈哈哈哈"];
}

- (IBAction)localNotificationCancel:(id)sender
{
    [LYJUnit _cancelLocalNotificationWithKey:@"test"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationItem.title isEqualToString:@"富文本"])
    {
        [self attributedText];
    }
    else if ([self.navigationItem.title isEqualToString:@"本地通知"])
    {
        [self localNotification];
    }

}

- (void)attributedText
{
    fullString = @"哈哈我高兴就哈哈要写框架哈哈哈我哈哈哈flilfifly";
    
    self.label.attributedText = [LYJUnit _attributedStringWithFullText:fullString andAttributedData:^(LYJUnitAttributedData *attributedData) {
        attributedData.dictionaryKeyAll(@"哈")
        .dictionaryColor([UIColor redColor])
        .dictionaryFont([UIFont systemFontOfSize:20])
        .dictionaryStrokeWidth(10);
        attributedData.dictionaryKeyAll(@"i")
        .dictionaryColor([UIColor blueColor])
        .dictionaryFont([UIFont systemFontOfSize:10])
        .dictionaryStrokeWidth(5);
    }];
}

- (void)localNotification
{
    if ([LYJUnit _ISIOS10])
    {
        
    }
    else
    {
        NSDate *newDate = [LYJUnit _dateNextType:LYJUnitDateNextTypeMinute targetDate:[NSDate new] andIndex:-1];
        //设置成一分钟后激活本地推送
        [LYJUnit _localNotificationWithDate:newDate alertBody:@"test" key:@"test" andIsNow:NO];
    }

}

@end
