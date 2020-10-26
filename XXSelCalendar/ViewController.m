//
//  ViewController.m
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import "XXSelCalendarVC.h"
#import "MyCollectionViewCell.h"

@interface ViewController ()<XXSelCalendarDataSource>
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController
{
    NSString *string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"点选" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(40, 80, 100, 40);
    [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn2];
    [btn2 setTitle:@"连选" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(40, 160, 100, 40);
    [btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    [self.view addSubview:self.label];
    self.label.textColor = [UIColor whiteColor];
    self.label.numberOfLines = 0;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn3];
    [btn3 setTitle:@"这是一个简单自定义" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(40, 460, 200, 40);
    [btn3 addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btn1Action:(UIButton *)btn
{
    XXSelCalendarVC *viewC = [[XXSelCalendarVC alloc] init];
    viewC.minLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];
    viewC.maxLimitDate = [viewC.minLimitDate dateByAddingMonths:3];
    viewC.selectType = SELCalenderTypePointSelection;
    [self.navigationController pushViewController:viewC animated:YES];
    viewC.xxSelCalenderDidSelectWithDates = ^(NSArray * _Nonnull dateArrStr) {
        NSString *str = [dateArrStr componentsJoinedByString:@"   &    "];
        self.label.text = str;
    };
}

- (void)btn2Action:(UIButton *)btn
{
    XXSelCalendarVC *viewC = [[XXSelCalendarVC alloc] init];
    viewC.minLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];
    viewC.maxLimitDate = [viewC.minLimitDate dateByAddingMonths:3];
    viewC.selectType = SELCalenderTypeContinuousSelection;
    viewC.selTimeLimit = SELCalenderTimeLimitMinute;
    [self.navigationController pushViewController:viewC animated:YES];
    viewC.xxSelCalenderDidSelectWithDates = ^(NSArray * _Nonnull dateArrStr) {
        NSString *str;
        if (dateArrStr.count > 1) {
            str = [NSString stringWithFormat:@"从%@到%@",dateArrStr.firstObject,dateArrStr.lastObject];
        } else {
            str = dateArrStr.firstObject;
        }
        self.label.text = str;
    };
}

- (void)btn3Action:(UIButton *)btn
{
    XXSelCalendarVC *viewC = [[XXSelCalendarVC alloc] init];
    viewC.minLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];
    viewC.maxLimitDate = [viewC.minLimitDate dateByAddingMonths:3];
    viewC.selectType = SELCalenderTypeContinuousSelection;
    [self.navigationController pushViewController:viewC animated:YES];
    
    viewC.xxSelCalenderDidSelectWithDates = ^(NSArray * _Nonnull dateArrStr) {
        NSString *str = [dateArrStr componentsJoinedByString:@"   &    "];
        self.label.text = str;
    };
    viewC.dataSource = self;
    [viewC registerClassWithClass:[MyCollectionViewCell class] andIdStr:@"MyCollectionViewCell"];
}

- (XXLCollectionViewCell *)selCalendar:(UICollectionView *)selCalendarCollectView cellForItemAtIndexPath:(NSIndexPath *)indexPath andDate:(NSDate *)date
{
    MyCollectionViewCell *cell = [selCalendarCollectView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    if (date) {
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld",date.day];
        cell.subL.text = date.chineseCalendarDateStr;
    } else {
        cell.dayLabel.text = @"";
        cell.subL.text = @"";
    }
    
    
    return cell;
}


@end
