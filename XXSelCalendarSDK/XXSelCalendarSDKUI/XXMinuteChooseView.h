//
//  XXMinuteChooseView.h
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseResult)(NSString *timeStr);

@interface XXMinuteChooseView : UIView

+ (XXMinuteChooseView *)startWithTime:(NSString *)timeStr;  //HH:mm

@property (nonatomic, copy) ChooseResult chooseResult;
@end

NS_ASSUME_NONNULL_END
