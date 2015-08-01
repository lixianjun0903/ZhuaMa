//
//  pickDateView.h
//  ZhuaMa
//
//  Created by xll on 15/1/22.
//  Copyright (c) 2015年 xll. All rights reserved.
//


#import "BaseADView.h"

@class PickDateView;

@protocol PickDateDelegate <NSObject>

-(void)didSelectDate:(NSString *)selectDate PickDateView:(PickDateView *)pickDateView;
-(void)removeView;
@end

@interface PickDateView : BaseADView
{
    UIView *shadowView;
    UIView *backView;
    NSString *pickDate;
    UIDatePicker *_datePicker;
    UILabel *titleLabel;
}
@property(nonatomic,copy)NSString *startDate;
@property(nonatomic,copy)NSString *stopDate;
@property(nonatomic,copy)NSString *showDate;
@property(nonatomic)BOOL isShowTitle;
@property(nonatomic)NSString *titleName;
@property(nonatomic)id<PickDateDelegate>delegate;
-(void)config;
@end
