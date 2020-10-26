//
//  XXLCollectionViewCell.h
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXLCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *unSelectTextColor;
@property (nonatomic, strong) UIColor *nowTextColor;
@property (nonatomic, strong) UIColor *selectBackColor;
@property (nonatomic, strong) UIColor *noSelectTextColor; //不允许选择的字体颜色
@end

NS_ASSUME_NONNULL_END
