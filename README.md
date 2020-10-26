# XXCalender
一个日历项目选择日期

    
    
    XXSelCalendarVC *viewC = [[XXSelCalendarVC alloc] init];
    viewC.minLimitDate = [NSDate dateWithTimeIntervalSinceNow:0];  //最小选择当前日期
    viewC.maxLimitDate = [viewC.minLimitDate dateByAddingMonths:3];  //最大选择三个月后
    viewC.selectType = SELCalenderTypePointSelection;
    [self.navigationController pushViewController:viewC animated:YES];
    viewC.xxSelCalenderDidSelectWithDates = ^(NSArray * _Nonnull dateArrStr) {
        NSString *str = [dateArrStr componentsJoinedByString:@"   &    "];
        NSLog(@"已经选择：%@",str);
    };
