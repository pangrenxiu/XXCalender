//
//  XXMinuteResultView.m
//  XXSelCalendar
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XXMinuteResultView.h"

@implementation XXMinuteResultView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.startDateL.text = @"";
    self.startWeekL.text = @"";
    self.startTimeL.text = @"";
    self.endDateL.text = @"";
    self.endWeekL.text = @"";
    self.endTimeL.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
