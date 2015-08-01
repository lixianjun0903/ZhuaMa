//
//  TimeSelectView.h
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "UUDatePicker.h"
@class TimeSelectView;
@protocol TimeSelectDelegate <NSObject>

-(void)timeSelect:(TimeSelectView *)timeSelectView TimeStr:(NSString *)timeStr;

@end

@interface TimeSelectView : BaseADView<UUDatePickerDelegate>
{
    NSString *timeStr;
}
@property(nonatomic)id<TimeSelectDelegate>delegate;
@end
