//
//  XXMinuteChooseView.m
//  XXSelCalendar
//
//  Created by apple on 2019/5/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "XXMinuteChooseView.h"

@interface XXMinuteChooseView ()
@property (weak, nonatomic) IBOutlet UIView *clockRoundView;
@property (nonatomic, strong) CALayer *sLayer;
@property (weak, nonatomic) IBOutlet UILabel *amLabel;
@property (weak, nonatomic) IBOutlet UILabel *pmLabel;
@property (weak, nonatomic) IBOutlet UILabel *hLabel;
@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@end

@implementation XXMinuteChooseView
{
    BOOL _isAM;
}

+ (XXMinuteChooseView *)startWithTime:(NSString *)timeStr
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    XXMinuteChooseView *view = [[NSBundle mainBundle] loadNibNamed:@"XXMinuteChooseView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    
    UIImage *image = [UIImage imageNamed:@"pointer.png"];
    view.sLayer = [[CALayer alloc]init];
    view.sLayer.bounds = CGRectMake(0, 0, (window.center.x-80)*image.size.width/image.size.height, window.center.x-80);
    view.sLayer.position = CGPointMake(window.center.x-80, window.center.x-80);
    view.sLayer.contents = (id)image.CGImage;
    view.sLayer.anchorPoint = CGPointMake(0.5, 0.9);
    [view.clockRoundView.layer addSublayer:view.sLayer];
    
    [window addSubview:view];
    view.clockRoundView.layer.cornerRadius = window.center.x-80;
    [view addGesture];
    
    NSInteger hour = [[timeStr componentsSeparatedByString:@":"].firstObject integerValue];
    NSInteger minute = [[timeStr componentsSeparatedByString:@":"].lastObject integerValue];
    if (hour >= 12) {
        hour = hour-12;
        view -> _isAM = NO;
        view.pmLabel.textColor = [UIColor whiteColor];
        view.amLabel.textColor = [UIColor lightTextColor];
    } else {
        view -> _isAM = YES;
        view.amLabel.textColor = [UIColor whiteColor];
        view.pmLabel.textColor = [UIColor lightTextColor];
    }
    NSInteger minuteNum = minute+hour*60;
    CGFloat percent = minuteNum/720.0;
    CGFloat angle = percent*2*M_PI;
    view.sLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    view.hLabel.text = [NSString stringWithFormat:@"%ld",hour];
    view.mLabel.text = [NSString stringWithFormat:@"%ld",minute];
    return view;
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *amtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(amTapAction)];
    [self.amLabel addGestureRecognizer:amtap];
    
    UITapGestureRecognizer *pmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pmTapAction)];
    [self.pmLabel addGestureRecognizer:pmTap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.clockRoundView addGestureRecognizer:pan];
}

- (void)tapAction
{
    [self removeFromSuperview];
}

- (void)amTapAction
{
    _isAM = YES;
    self.amLabel.textColor = [UIColor whiteColor];
    self.pmLabel.textColor = [UIColor lightTextColor];
}

- (void)pmTapAction
{
    _isAM = NO;
    self.pmLabel.textColor = [UIColor whiteColor];
    self.amLabel.textColor = [UIColor lightTextColor];
}

- (void)panAction:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self.clockRoundView];
    
    CGPoint centerPoint = CGPointMake([UIApplication sharedApplication].delegate.window.center.x-80, [UIApplication sharedApplication].delegate.window.center.x-80);
    CGFloat x = tapPoint.x-centerPoint.x;
    CGFloat y = centerPoint.y-tapPoint.y;
    CGFloat angle = atan(x/y);
    if (y < 0) {
        angle = angle+M_PI;
    }
    self.sLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);

    if (angle < 0) {
        angle = 2*M_PI+angle;
    }
    CGFloat percent = angle/(2*M_PI);
    NSInteger minuteNumber = percent*720;
    NSInteger hour = minuteNumber/60;
    NSInteger minute = minuteNumber%60;
    if (hour == 0) {
        hour = 12;
    }
    self.hLabel.text = [NSString stringWithFormat:@"%02ld",hour];
    self.mLabel.text = [NSString stringWithFormat:@"%02ld",minute];
}

- (IBAction)sureAction:(id)sender {
    NSInteger hour = [self.hLabel.text integerValue];
    if (!_isAM) {
        hour = hour+12;
    }
    self.chooseResult([NSString stringWithFormat:@"%ld:%@",hour,self.mLabel.text]);
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
