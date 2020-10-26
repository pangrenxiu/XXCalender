//
//  XXSelCalendarVC.h
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXLCollectionViewCell.h"
#import "NSDate+Extension.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,SELCalenderType){
    SELCalenderTypeContinuousSelection,
    SELCalenderTypePointSelection,
};

typedef NS_ENUM(NSUInteger,SELCalenderTimeLimit){
    SELCalenderTimeLimitDay,
    SELCalenderTimeLimitMinute,
};

@protocol XXSelCalendarDataSource <NSObject>

@optional
- (XXLCollectionViewCell *)selCalendar:(UICollectionView *)selCalendarCollectView cellForItemAtIndexPath:(NSIndexPath *)indexPath andDate:(NSDate *)date;

@end

@protocol XXSelCalendarDelegate <NSObject>


@end

typedef void(^XXSelCalenderSelect)(NSArray *dateArrStr);

@interface XXSelCalendarVC : UIViewController

- (void)registerClassWithClass:(nullable Class)aClass andIdStr:(NSString *)idStr;
@property (nonatomic, assign) id<XXSelCalendarDataSource> dataSource;

@property (nonatomic, strong) NSDate *minLimitDate;
@property (nonatomic, strong) NSDate *maxLimitDate;
@property (nonatomic, assign) SELCalenderType selectType;
@property (nonatomic, assign) SELCalenderTimeLimit selTimeLimit;

@property (nonatomic, assign) NSInteger maxDayNumber; //限制天数

@property (nonatomic, copy) XXSelCalenderSelect xxSelCalenderDidSelectWithDates;

@end

NS_ASSUME_NONNULL_END
