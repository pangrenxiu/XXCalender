//
//  XXLCollectionViewCell.m
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XXLCollectionViewCell.h"

@implementation XXLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectTextColor = [UIColor whiteColor];
        self.nowTextColor = [UIColor redColor];
        self.selectBackColor = [UIColor redColor];
        self.unSelectTextColor = [UIColor blackColor];
        self.noSelectTextColor = [UIColor lightGrayColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView alloc] init];
        [self.contentView addSubview:self.backView];
        
        self.dayLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.dayLabel];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        
        self.backView.frame = self.bounds;
        self.dayLabel.frame = self.bounds;
    }
    return self;
}

//- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    [super applyLayoutAttributes:layoutAttributes];
//    self.backView.frame = self.bounds;
//    self.dayLabel.frame = self.bounds;
//}
@end
