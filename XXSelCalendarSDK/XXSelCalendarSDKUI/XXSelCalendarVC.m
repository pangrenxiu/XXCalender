//
//  XXSelCalendarVC.m
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XXSelCalendarVC.h"
#import "XXMinuteResultView.h"
#import "XXMinuteChooseView.h"

@interface XXSelCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *yearMonthLabel;
@property (nonatomic, strong) UICollectionView *calendarCollectionView;
@property (nonatomic, strong) NSDate *chooseMonthDate;

@property (nonatomic, strong) XXMinuteResultView *resultView;
@property (nonatomic, strong) XXMinuteChooseView *minuteChooseView;
@end

@implementation XXSelCalendarVC
{
    NSArray *_countArray;
    NSMutableArray *_weekArray; //每月第一天是周几的数组
    NSDate *_nowDate;
    
    NSArray *_weekHeadArray;
    
    NSMutableArray *_chooseDateArray;
    NSString *_startStr;
    NSString *_endStr;
    
    NSMutableArray *_regClassArr;
    NSMutableArray *_idStrArr;
}

- (void)registerClassWithClass:(nullable Class)aClass andIdStr:(NSString *)idStr
{
    if (!_regClassArr) {
        _regClassArr = [NSMutableArray array];
    }
    if (!_idStrArr) {
        _idStrArr = [NSMutableArray array];
    }
    [_regClassArr addObject:aClass];
    [_idStrArr addObject:idStr];
    [self.calendarCollectionView registerClass:aClass forCellWithReuseIdentifier:idStr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setDefault];
    
    [self getDateArrayWithSelDate:_nowDate];
    
    [self setUpHeadUI];
    [self setUpCalenderUI];
    [self setButtomBtn];
    if (self.selTimeLimit == SELCalenderTimeLimitMinute) {
        [self setMinusChooseUI];
    }
}

- (void)setDefault
{
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate dateWithDaysBeforeNow:365];
    }
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate dateWithDaysFromNow:365];
    }
    _chooseDateArray = [NSMutableArray array];
    _nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    self.chooseMonthDate = _nowDate;
    _weekHeadArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

- (void)setUpHeadUI
{
    self.yearMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 30)];
    [self.view addSubview:self.yearMonthLabel];
    self.yearMonthLabel.text = [_nowDate stringWithFormat:@"YYYY年MM月"];
    self.yearMonthLabel.font = [UIFont boldSystemFontOfSize:30];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"cha.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(self.view.bounds.size.width-50, 10, 30, 30);
    [btn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setButtomBtn
{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor redColor];
    
    if (@available(iOS 11.0, *)) {
        sureBtn.frame = CGRectMake(0, self.view.bounds.size.height-44-[UIApplication sharedApplication].delegate.window.safeAreaInsets.top-[UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom-50, self.view.bounds.size.width, 50);
    } else {
        // Fallback on earlier versions
        sureBtn.frame = CGRectMake(0, self.view.bounds.size.height-44-20-50, self.view.bounds.size.width, 50);
    }
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)setUpCalenderUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.calendarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.width) collectionViewLayout:layout];
    
    self.calendarCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.calendarCollectionView.delegate = self;
    self.calendarCollectionView.dataSource = self;
    
    [self.calendarCollectionView registerClass:[XXLCollectionViewCell class] forCellWithReuseIdentifier:@"XXLCollectionViewCell"];
    for (NSInteger i = 0; i < _regClassArr.count; i++) {
        Class aclass = _regClassArr[i];
        NSString *str = _idStrArr[i];
        [self.calendarCollectionView registerClass:aclass forCellWithReuseIdentifier:str];
    }
    
    [self.view addSubview:self.calendarCollectionView];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDirectionRight:)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDirectionLeft:)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)setMinusChooseUI
{
    self.resultView = [[NSBundle mainBundle] loadNibNamed:@"XXMinuteResultView" owner:self options:nil].firstObject;
    self.resultView.frame = CGRectMake(0, self.view.bounds.size.width+40, self.view.bounds.size.width, 100);
    [self.view addSubview:self.resultView];
    
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTimeChooseAction:)];
    [self.resultView.startTapView addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTimeChooseAction:)];
    [self.resultView.endTapView addGestureRecognizer:endTap];
}

- (void)startTimeChooseAction:(UITapGestureRecognizer *)tap
{
    XXMinuteChooseView *chooseV = [XXMinuteChooseView startWithTime:[_nowDate stringWithFormat:@"HH:mm"]];
    [chooseV setChooseResult:^(NSString * _Nonnull timeStr) {
        self->_chooseDateArray[0] = [NSString stringWithFormat:@"%@ %@",[self->_chooseDateArray.firstObject componentsSeparatedByString:@" "].firstObject,timeStr];
        [self exchangeMinuteView];
    }];
}

- (void)endTimeChooseAction:(UITapGestureRecognizer *)tap
{
    
    XXMinuteChooseView *chooseV = [XXMinuteChooseView startWithTime:[_nowDate stringWithFormat:@"HH:mm"]];
    [chooseV setChooseResult:^(NSString * _Nonnull timeStr) {
        self->_chooseDateArray[self->_chooseDateArray.count-1] = [NSString stringWithFormat:@"%@ %@",[self->_chooseDateArray.lastObject componentsSeparatedByString:@" "].firstObject,timeStr];
        [self exchangeMinuteView];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        XXLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XXLCollectionViewCell" forIndexPath:indexPath];
        
        cell.dayLabel.text = _weekHeadArray[indexPath.item];
        cell.backView.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        XXLCollectionViewCell *cell;

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XXLCollectionViewCell" forIndexPath:indexPath];

        NSInteger inte = indexPath.item+1-[_weekArray[self.chooseMonthDate.month-1] integerValue];
        if (inte > 0) {
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld",inte];
        } else {
            cell.dayLabel.text = @"";
        }
        NSString *selStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.chooseMonthDate.year,self.chooseMonthDate.month,inte];
        
        
        NSString *selectMinDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld-23-59-59",self.chooseMonthDate.year, self.chooseMonthDate.month, inte];
        NSDate *selectMindate = [NSDate date:selectMinDateStr WithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        
        NSString *selectMaxDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld-00-00-01",self.chooseMonthDate.year, self.chooseMonthDate.month, inte];
        NSDate *selectMaxdate = [NSDate date:selectMaxDateStr WithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(selCalendar:cellForItemAtIndexPath:andDate:)]) {
            NSString *selectDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.chooseMonthDate.year, self.chooseMonthDate.month, inte];
            NSDate *selectdate = [NSDate date:selectDateStr WithFormat:@"yyyy-MM-dd"];
            cell = [self.dataSource selCalendar:collectionView cellForItemAtIndexPath:indexPath andDate:selectdate];
        }
        
        
        
        /**
         颜色设置
         **/
        if ([selStr isEqualToString:[NSString stringWithFormat:@"%ld-%02ld-%02ld",_nowDate.year,_nowDate.month,_nowDate.day]]) {
            if ([_chooseDateArray containsObject:selStr]) {
                cell.backView.backgroundColor = cell.selectBackColor;
                cell.dayLabel.textColor = cell.selectTextColor;
            } else {
                cell.backView.backgroundColor = [UIColor clearColor];
                cell.dayLabel.textColor = cell.nowTextColor;
            }
        } else {
            if ([_chooseDateArray containsObject:selStr]) {
                cell.backView.backgroundColor = cell.selectBackColor;
                cell.dayLabel.textColor = cell.selectTextColor;
            } else {
                cell.backView.backgroundColor = [UIColor clearColor];
                cell.dayLabel.textColor = cell.unSelectTextColor;
            }
        }
        if ([selectMindate timeIntervalSince1970] < [self.minLimitDate timeIntervalSince1970] || [selectMaxdate timeIntervalSince1970] > [self.maxLimitDate timeIntervalSince1970]) {
            cell.dayLabel.textColor = cell.noSelectTextColor;
        }
        /**
         颜色设置
         **/
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    return [_countArray[self.chooseMonthDate.month-1] integerValue]+[_weekArray[self.chooseMonthDate.month-1] integerValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger inte = indexPath.item+1-[_weekArray[self.chooseMonthDate.month-1] integerValue];
    if (inte > 0) {
        NSString *selectMinDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld-23-59-59",self.chooseMonthDate.year, self.chooseMonthDate.month, inte];
        NSDate *selectMindate = [NSDate date:selectMinDateStr WithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        
        NSString *selectMaxDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld-00-00-01",self.chooseMonthDate.year, self.chooseMonthDate.month, inte];
        NSDate *selectMaxdate = [NSDate date:selectMaxDateStr WithFormat:@"yyyy-MM-dd-HH-mm-ss"];
        
        NSString *selectDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",self.chooseMonthDate.year, self.chooseMonthDate.month, inte];
        NSDate *selectdate = [NSDate date:selectDateStr WithFormat:@"yyyy-MM-dd"];
        
        if ([selectMindate timeIntervalSince1970] >= [self.minLimitDate timeIntervalSince1970] && [selectMaxdate timeIntervalSince1970] <= [self.maxLimitDate timeIntervalSince1970]) {
            
            if (self.selectType == SELCalenderTypePointSelection) {
                if ([_chooseDateArray containsObject:selectDateStr]) {
                    [_chooseDateArray removeObject:selectDateStr];
                } else {
                    [_chooseDateArray addObject:selectDateStr];
                }
            } else {
                if (_chooseDateArray.count == 0) {
                    [_chooseDateArray addObject:selectDateStr];
                } else if (_chooseDateArray.count == 1) {
                    if ([_chooseDateArray containsObject:selectDateStr]) {
                        [_chooseDateArray removeObject:selectDateStr];
                    } else {
                        if ([[NSDate date:_chooseDateArray.firstObject WithFormat:@"yyyy-MM-dd"] timeIntervalSince1970] < [selectdate timeIntervalSince1970]) {
                            NSInteger chooseMoreCount = [selectdate daysAfterDate:[NSDate date:_chooseDateArray.firstObject WithFormat:@"yyyy-MM-dd"]];
                            for (NSInteger i = 1; i <= chooseMoreCount; i++) {
                                NSDate *date = [[NSDate date:_chooseDateArray.firstObject WithFormat:@"yyyy-MM-dd"] dateByAddingDays:i];
                                NSString *str = [date stringWithFormat:@"yyyy-MM-dd"];
                                [_chooseDateArray addObject:str];
                            }
                        } else {
                            [_chooseDateArray removeAllObjects];
                            [_chooseDateArray addObject:selectDateStr];
                        }
                    }
                } else {
                    [_chooseDateArray removeAllObjects];
                    [_chooseDateArray addObject:selectDateStr];
                }
                if (self.selTimeLimit == SELCalenderTimeLimitMinute) {
                    [self exchangeMinuteView];
                }
            }
            [self.calendarCollectionView reloadData];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/7.0, self.view.bounds.size.width/7.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --------- 向右滑动手势（上月）
- (void)handleSwipeDirectionRight:(UISwipeGestureRecognizer *)recognizer
{
    if (self.chooseMonthDate.month > self.minLimitDate.month) {
        self.chooseMonthDate = [self.chooseMonthDate dateByAddingMonths:-1];
        [self getDateArrayWithSelDate:self.chooseMonthDate];
        [self.calendarCollectionView reloadData];
    } else if (self.chooseMonthDate.year > self.minLimitDate.year) {
        self.chooseMonthDate = [self.chooseMonthDate dateByAddingMonths:-1];
        [self getDateArrayWithSelDate:self.chooseMonthDate];
        [self.calendarCollectionView reloadData];
    }
}

#pragma mark --------- 向左滑动手势（下月）
- (void)handleSwipeDirectionLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (self.chooseMonthDate.month < self.maxLimitDate.month) {
        self.chooseMonthDate = [self.chooseMonthDate dateByAddingMonths:1];
        [self getDateArrayWithSelDate:self.chooseMonthDate];
        [self.calendarCollectionView reloadData];
    } else if (self.chooseMonthDate.year < self.maxLimitDate.year) {
        self.chooseMonthDate = [self.chooseMonthDate dateByAddingMonths:1];
        [self getDateArrayWithSelDate:self.chooseMonthDate];
        [self.calendarCollectionView reloadData];
    }
}

#pragma mark ----------------- 清除按钮
- (void)clearAction
{
    [_chooseDateArray removeAllObjects];
    [self.calendarCollectionView reloadData];
}

#pragma mark ----------------- 确认选择
- (void)sureBtnAction:(UIButton *)btn
{
    if (self.selectType == SELCalenderTypePointSelection) {
        if (_chooseDateArray.count < 1) {
            NSLog(@"未选择");
            return;
        }
    }
    if (self.selectType == SELCalenderTypeContinuousSelection) {
        if (_chooseDateArray.count < 2) {
            NSLog(@"请选择开始到结束日期");
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.xxSelCalenderDidSelectWithDates(_chooseDateArray);
}

- (void)exchangeMinuteView
{
    if (_chooseDateArray.count > 0) {
        NSDate *firstDate;
        if ([_chooseDateArray[0] length] < 11) {
            firstDate = [NSDate date:_chooseDateArray[0] WithFormat:@"yyyy-MM-dd"];
            self.resultView.startTimeL.text = @"请选择";
        } else {
            firstDate = [NSDate date:_chooseDateArray[0] WithFormat:@"yyyy-MM-dd HH:mm"];
            self.resultView.startTimeL.text =[_chooseDateArray[0] componentsSeparatedByString:@" "].lastObject;
        }
        self.resultView.startDateL.text = [firstDate stringWithFormat:@"MM月dd日"];
        self.resultView.startWeekL.text = [NSString stringWithFormat:@"周%@",_weekHeadArray[firstDate.weekday-1]];
        if (_chooseDateArray.count > 1) {
            
            NSDate *endDate;
            if ([_chooseDateArray.lastObject length] < 11) {
                endDate = [NSDate date:_chooseDateArray.lastObject WithFormat:@"yyyy-MM-dd"];
                self.resultView.endTimeL.text = @"请选择";
            } else {
                endDate = [NSDate date:_chooseDateArray.lastObject WithFormat:@"yyyy-MM-dd HH:mm"];
                self.resultView.endTimeL.text =[_chooseDateArray.lastObject componentsSeparatedByString:@" "].lastObject;
            }
            self.resultView.endDateL.text = [endDate stringWithFormat:@"MM月dd日"];
            self.resultView.endWeekL.text = [NSString stringWithFormat:@"周%@",_weekHeadArray[endDate.weekday-1]];
            
        } else {
            self.resultView.endDateL.text = @"";
            self.resultView.endWeekL.text = @"";
            self.resultView.endTimeL.text = @"";
        }
    } else {
        self.resultView.startDateL.text = @"";
        self.resultView.startWeekL.text = @"";
        self.resultView.startTimeL.text = @"";
    }
}

- (void)getDateArrayWithSelDate:(NSDate *)selDate
{
    self.yearMonthLabel.text = [selDate stringWithFormat:@"YYYY年MM月"];
    BOOL isrunNian = selDate.year%4==0 ? (selDate.year%100==0? (selDate.year%400==0?YES:NO):YES):NO;
    if (isrunNian) {
        _countArray = @[@31,@29,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31];
    } else {
        _countArray = @[@31,@28,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31];
    }
    
    _weekArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= 12; i++) {
        NSDate *date = [NSDate date:[NSString stringWithFormat:@"%ld-%02ld-01 16",selDate.year,i] WithFormat:@"YYYY-MM-dd HH"];
        [_weekArray addObject:[NSNumber numberWithInteger:date.weekday-1]];
    }
}

#pragma mark ----------- setter
- (void)setChooseMonthDate:(NSDate *)chooseMonthDate
{
    _chooseMonthDate = chooseMonthDate;
    [self.calendarCollectionView reloadData];
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
