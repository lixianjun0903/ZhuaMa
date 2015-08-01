//
//  pickDateView.m
//  ZhuaMa
//
//  Created by xll on 15/1/22.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PickDateView.h"

@implementation PickDateView

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
    shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, vHEIGHT, vWIDTH, 216+30+40)];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    
    [UIView animateWithDuration:0.3 animations:^{
        backView.frame = CGRectMake(0, vHEIGHT - 216-30 - 40, vWIDTH, 216+30 + 40);
    }];
    
    
    
    titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, vWIDTH, 40) title:nil font:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.hidden = YES;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [backView addSubview:titleLabel];
    
    
    UIView * bgView = [MyControll createViewWithFrame:CGRectMake(0, 40, vWIDTH, 216+30)];
    bgView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bgView];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, vWIDTH, 216 )];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //日期模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
   
    [bgView addSubview:_datePicker];

    UIButton *cancelBtn = [MyControll createButtonWithFrame:CGRectMake(20, 5, 40, 20) bgImageName:nil imageName:nil title:@"取消" selector:@selector(dateClick:) target:self];
    cancelBtn.tag = 431;
    [bgView addSubview:cancelBtn];
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH - 60, 5, 40, 20) bgImageName:nil imageName:nil title:@"确定" selector:@selector(dateClick:) target:self];
    confirmBtn.tag = 432;
    [bgView addSubview:confirmBtn];
}
-(void)config
{
    
    titleLabel.hidden = !_isShowTitle;
    titleLabel.text = _titleName;
     //定义最小日期
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *maxDate = [formatter_minDate dateFromString:_stopDate];
    NSDate *minDate = [formatter_minDate dateFromString:_startDate];
    [_datePicker setMinimumDate:minDate];
    [_datePicker setMaximumDate:maxDate];
    if (!pickDate) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        pickDate = [formatter stringFromDate:[NSDate date]];
                pickDate = _showDate;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [_datePicker setDate:[formatter dateFromString:_showDate]];
    [_datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
}
-(void)dateClick:(UIButton *)sender
{
    if (sender.tag == 432) {
        [UIView animateWithDuration:0.3 animations:^{
            backView.frame = CGRectMake(0, vHEIGHT, vWIDTH, 216+30 + 40);
        } completion:^(BOOL finished) {
           [_delegate didSelectDate:pickDate PickDateView:self];
        }];
    }
    else if(sender.tag == 431)
    {
        [self removeView:nil];
    }
}
-(void)dataValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    pickDate = [formatter stringFromDate:date_one];
}
-(void)removeView:(UIGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        backView.frame = CGRectMake(0, vHEIGHT, vWIDTH, 216+30 + 40);
    } completion:^(BOOL finished) {
        [_delegate removeView];
    }];
    
}
@end
