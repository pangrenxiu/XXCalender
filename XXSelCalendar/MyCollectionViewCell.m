//
//  MyCollectionViewCell.m
//  XXSelCalendar
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, self.contentView.bounds.size.width, 16)];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self.dayLabel addSubview:label];
        self.subL = label;
    }
    return self;
}

@end
