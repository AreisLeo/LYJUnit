//
//  ViewController.m
//  LYJUnitPublic
//
//  Created by Aries li on 2017/5/23.
//  Copyright © 2017年 Aries li. All rights reserved.
//

#import "ViewController.h"
#import "LYJTestModel.h"
#import "LYJUnitHeader.h"
#import "LYJRadarView.h"
@interface ViewController ()
{
    NSString *fullString;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (IBAction)tap:(id)sender {


    self.label.attributedText = [LYJUnit _attributedStringWithFullText:fullString andAttributedData:^(LYJUnitAttributedData *attributedData) {
        attributedData.fullTextDictionary
        .dictionaryColor([UIColor redColor])
        .dictionaryFont([UIFont systemFontOfSize:20])
        .dictionaryStrokeWidth(5);
        
        attributedData.dictionaryKeyAll(@"我")
        .dictionaryColor([UIColor blueColor])
        .dictionaryFont([UIFont systemFontOfSize:25])
        .dictionaryStrokeWidth(5);
        
        attributedData.dictionaryKeyAndCount(@"我", 1)
        .dictionaryColor([UIColor yellowColor])
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
    else if ([self.navigationItem.title isEqualToString:@"时间操作"])
    {
        [self dateController];
    }
    else if ([self.navigationItem.title isEqualToString:@"排序操作"])
    {
        [self quickSort];
    }
    else if ([self.navigationItem.title isEqualToString:@"图像变化"])
    {
        [self imageChange];
    }
    else if ([self.navigationItem.title isEqualToString:@"扫描二维码"])
    {
        [self scanCode];
    }
    else if ([self.navigationItem.title isEqualToString:@"显示提示框"])
    {

    }
    else if ([self.navigationItem.title isEqualToString:@"runtime"])
    {
        [LYJUnit _classCopyPropertyListWithTarget:self confirmBlock:^(id value, NSString *propertyName) {
            //            NSLog(@"%@ %@",value ,propertyName);
        }];
        
        [LYJUnit _classCopyIvarListWithTarget:self confirmBlock:^(id value, NSString *key) {
            //            NSLog(@"%@ %@",value ,key);
        }];
        [LYJUnit _classCopyMethodListWithClass:[self class] confirmBlock:^(NSString *methodName) {
            NSLog(@"%@",methodName);
        }];
        
        [LYJUnit _classCopyMethodListWithTarget:[self class] confirmBlock:^(SEL method, NSString *methodName) {
            
            NSLog(@"%@",methodName);
        }];
    }
    else if ([self.navigationItem.title isEqualToString:@"KVO"])
    {
        UILabel *label = [UILabel new];
        label.tag = 999;
//        [[LYJUnit _addObserver:label forKeyPath:@"text" valueChangeBlock:^(id newValue, id oldValue, id object, NSString *keyPath) {
//            
//         }]removeObserverWithSEL:@selector(viewDidDisappear:) removeBlock:^{
//             NSLog(@"删除");
//        }];

        [self LYJ_addObserver:label forKeyPath:@"text" valueChangeBlock:^(id newValue, id oldValue, id object, NSString *keyPath) {
            NSLog(@"%@",keyPath);
        }];
        
        label.text = @"1";
        [self.view addSubview:label];
    }
    else if ([self.navigationItem.title isEqualToString:@"雷达演示"])
    {
        [self showRadar];
    }
    else if ([self.navigationItem.title isEqualToString:@"弹性动画"])
    {
//        [self showSpring];
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
       UNNotificationTrigger *trigger = [LYJUnit _UNNotificationTriggerWithType:LYJUnitNotificationTriggerTypeTimeInterval item:@60 andRepeats:NO];
        [LYJUnit _UNUserNotificationWithTitle:@"标题" subtitle:@"小标题" body:@"正文" identifier:@"2017" badge:@0 trigger:trigger];
    }
    else
    {
        NSDate *newDate = [LYJUnit _dateNextType:LYJUnitDateNextTypeMinute targetDate:[NSDate new] andIndex:-1];
        //设置成一分钟后激活本地推送
        [LYJUnit _localNotificationWithDate:newDate alertBody:@"test" key:@"test" andIsNow:NO];
    }
}

- (void)dateController
{
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeYYYYMMDDHHMMSS andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeYYYYMMDDHHMM andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeYYYYMMDDHH andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeYYYYMMDD andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeMMDD andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeDD andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeHHMMSS andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeHHMM andTargetDate:[NSDate new]]);
    NSLog(@"%@",[LYJUnit _dateStrFromDateType:LYJUnitDateTypeHH andTargetDate:[NSDate new]]);
}

- (void)quickSort
{
    NSMutableArray *targetModels = [NSMutableArray array];
    NSInteger i = 0;
    while (i < 10)
    {
        LYJTestModel *model = [LYJTestModel new];
        model.value = (arc4random() % 100000 )/ 1000.0f;
        [targetModels addObject:model];
        i++;
    }
    NSMutableArray *testModels1 = [NSMutableArray arrayWithArray:targetModels];
    NSMutableArray *testModels2 = [NSMutableArray arrayWithArray:targetModels];
    //升序
    NSMutableString *testStr = [NSMutableString string];
    [LYJUnit _ascendQuickSortArray:testModels1 andKeyPath:@"value"];
    for (LYJTestModel *model in testModels1)
    {
        
        [testStr appendFormat:@"%f,",model.value];
    }
    NSLog(@"升序 === %@",testStr);
    //降序
    testStr = [NSMutableString string];
    [LYJUnit _descendQuickSortArray:testModels2 andKeyPath:@"value"];
    for (LYJTestModel *model in testModels2)
    {
        [testStr appendFormat:@"%f,",model.value];
    }
    NSLog(@"降序 === %@",testStr);
}

- (void)imageChange
{
    
    self.ImageView1.image = [LYJUnit _changeChromaWithTargetImage:self.ImageView1.image type:1];
    
    self.imageView2.image = [LYJUnit _imageModelAlwaysTemplateWithImage:self.imageView2.image];
    self.imageView2.tintColor = [UIColor greenColor];
    
    self.imageView3.image = [LYJUnit _zipImageWithImage:self.imageView3.image];
}
- (void)scanCode
{
    [LYJUnit _showScanWithView:self.view complete:^(NSString *result) {
        
    }];
}

- (IBAction)alertviewone:(id)sender
{
    [self showAlertType:0];
}

- (IBAction)alertviewtwo:(id)sender
{
    [self showAlertType:1];
}


- (IBAction)actionsheetone:(id)sender
{
    [self showAlertType:2];
}


- (IBAction)actionsheettwo:(id)sender
{
    [self showAlertType:3];
}


- (IBAction)actionsheetThree:(id)sender
{
    [self showAlertType:4];
}

- (void)showAlertType:(NSInteger)type
{
    switch (type)
    {
        case 0:
        {
            [LYJUnit _showAlertViewWithTitle:@"title" message:@"message" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定",@"我才不相信",@"哈哈"]viewController:self clickBlock:^(NSInteger index) {
                NSLog(@"%ld",index);
            }];
        }
            break;
        case 1:
        {
            [LYJUnit _showAlertViewWithTitle:@"title" message:@"message" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定",@"我才不相信",@"哈哈"]viewController:self textFieldCount:3 textFieldsBlock:^(NSMutableArray *textFields) {
                NSLog(@"\ntextFields === %@",textFields);
            } textChangeBlock:^(UITextField *textField, NSString *newText) {
                NSLog(@"\ntextField === %@ ,newText === %@",textField,newText);
            } clickBlock:^(NSInteger index) {
                NSLog(@"\nindex === %ld",index);
            }];

        }
            break;
        case 2:
        {
            [LYJUnit _showActionSheetWithTitle:@"title" message:@"message" cancelButtonTitle:@"取消" destructiveTitle:@"destructiveTitle" otherButtonTitles:@[@"确定",@"我才不相信",@"哈哈"] viewController:self clickBlock:^(NSInteger index) {
                NSLog(@"%ld",index);
            }];
        }
            break;
        case 3:
        {
            [LYJUnit _showActionSheetWithTitle:@"title" message:@"message" cancelButtonTitle:nil destructiveTitle:@"destructiveTitle" otherButtonTitles:@[@"确定",@"我才不相信",@"哈哈"] viewController:self clickBlock:^(NSInteger index) {
                NSLog(@"%ld",index);
            }];
        }
            break;
        case 4:
        {
             [LYJUnit _showActionSheetWithTitle:@"title" message:@"message" cancelButtonTitle:nil destructiveTitle:nil otherButtonTitles:@[@"确定",@"我才不相信",@"哈哈"] viewController:self clickBlock:^(NSInteger index) {
                NSLog(@"%ld",index);
            }];

        }
            break;
        default:
            break;
    }
}

- (void)showRadar
{
    LYJRadarView *radarView = [[LYJRadarView alloc]initWithFrame:self.view.bounds];
    radarView.backgroundColor = [UIColor clearColor];
    radarView.indicatorStartColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    radarView.frame = ({
        CGRect frame  = radarView.frame;
        frame.origin = CGPointMake(0, 64);
        frame.size = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) / 2.0f);
        frame;
    });
    radarView.pointViewPadding = 20;
    radarView.sectionsNum = 4;
    
    radarView.radius = (CGRectGetWidth(self.view.bounds) - 60) / 2.0f;
    radarView.pointSize = CGSizeMake(70, 77);
    [self.view addSubview:radarView];
    [radarView scan];
}


- (void)dealloc
{
    [LYJUnit _hiddenScanViewWithRemove:YES];
    UIView *view = [self.view viewWithTag:999];
    [self LYJ_removeObserver:view forKeyPath:@"text"];
    NSLog(@"%s",__func__);
}

@end
