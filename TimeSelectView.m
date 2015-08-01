//
//  TimeSelectView.m
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TimeSelectView.h"

@implementation TimeSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    NSDate *now = [NSDate date];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, vHEIGHT-256, vWIDTH, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UIButton *cancelBtn = [MyControll createButtonWithFrame:CGRectMake(20, 0, 60, 40) bgImageName:nil imageName:nil title:@"取消" selector:@selector(cancelClick) target:self];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH-80, 0, 60, 40) bgImageName:nil imageName:nil title:@"确定" selector:@selector(confirmClick) target:self];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:confirmBtn];
    
    UUDatePicker *datePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(0, vHEIGHT-216, vWIDTH, 216)
                                                        Delegate:self
                                                     PickerStyle:UUDateStyle_YearMonthDayHourMinute];
    datePicker.ScrollToDate = now;
//    datePicker.maxLimitDate = now;
    datePicker.minLimitDate = now;
    [self addSubview:datePicker];
}
-(void)cancelClick
{
    [self tap:nil];
}
-(void)confirmClick
{
    if (!timeStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeStr = [formatter stringFromDate:[NSDate date]];
    }
    [_delegate timeSelect:self TimeStr:timeStr];
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate timeSelect:self TimeStr:@"0"];
}
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    timeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
}

@end
