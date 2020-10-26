//
//  XXMinuteResultView.h
//  XXSelCalendar
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMinuteResultView : UIView
@property (weak, nonatomic) IBOutlet UILabel *startWeekL;
@property (weak, nonatomic) IBOutlet UILabel *startDateL;
@property (weak, nonatomic) IBOutlet UILabel *startTimeL;
@property (weak, nonatomic) IBOutlet UILabel *endWeekL;
@property (weak, nonatomic) IBOutlet UILabel *endDateL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeL;
@property (weak, nonatomic) IBOutlet UIView *startTapView;
@property (weak, nonatomic) IBOutlet UIView *endTapView;

@end

NS_ASSUME_NONNULL_END
