# XXCalender
一个日历项目选择日期

将XXSelCalendarSDK文件夹导入项目中即可使用。
用法在ViewController中。
    XXSelCalendarVC *viewC = [[XXSelCalendarVC alloc] init];
    viewC.minLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];       //最小限制当前时间
    viewC.maxLimitDate = [viewC.minLimitDate dateByAddingMonths:3];     //最大可以选择3个月后
    viewC.selectType = SELCalenderTypePointSelection;
    [self.navigationController pushViewController:viewC animated:YES];
    viewC.xxSelCalenderDidSelectWithDates = ^(NSArray * _Nonnull dateArrStr) {
        NSString *str = [dateArrStr componentsJoinedByString:@"   &    "];
        NSLog(@"选择的日期为：%@",str);
    };
