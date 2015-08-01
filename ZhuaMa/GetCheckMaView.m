//
//  GetCheckMaView.m
//  ZhuaMa
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "GetCheckMaView.h"
#import "RegexKitLite.h"
@implementation GetCheckMaView
{
    UILabel *showLabel;
    UIButton *getBtn;
    NSTimer *timer;
    int timeCount;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 1, frame.size.height-20)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        timeCount = 60;
        showLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) title:nil font:15];
        showLabel.text = @"已发送";
        showLabel.textAlignment = NSTextAlignmentCenter;
        showLabel.hidden = YES;
        [self addSubview:showLabel];
        
        getBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) bgImageName:nil imageName:nil title:@"获取验证码" selector:@selector(getClick) target:self];
        getBtn.hidden = NO;
        getBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [getBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:getBtn];
    }
    return self;
}
-(void)getClick
{
    [_delegate buttonClick];
}
-(void)startCheck
{
    if (_delegate && [_delegate respondsToSelector:@selector(getCheckMa)]) {
        [_delegate getCheckMa];
    }
    timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCut) userInfo:nil repeats:YES];
    showLabel.hidden = NO;
    getBtn.hidden = YES;
}
-(void)timeCut
{
    showLabel.text = [NSString stringWithFormat:@"还剩%d秒",timeCount];
    timeCount--;
    if (timeCount < 0) {
       [timer invalidate];
        getBtn.hidden = NO;
        showLabel.hidden = YES;
        [getBtn setTitle:@"再次获取" forState:UIControlStateNormal];
        showLabel.text = @"已发送";
        timeCount = 60;
    }
}
- (void)dealloc{
    NSLog(@"被销毁");
}
@end
