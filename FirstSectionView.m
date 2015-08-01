//
//  FirstSectionView.m
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "FirstSectionView.h"

@implementation FirstSectionView

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
    topSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, 130)];
    topSC.backgroundColor = [UIColor whiteColor];
    topSC.showsHorizontalScrollIndicator = NO;
    topSC.pagingEnabled = YES;
    [self addSubview:topSC];
    
    pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(vWIDTH/2, 100, vWIDTH/2, 30)];
    [self addSubview:pageControll];
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, vWIDTH, 100)];
    midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:midView];
    
    NSArray *midImageArray = @[@"24@2x_12",@"24@2x_14",@"24@2x_16",@"24@2x_18"];
    for (int i=0; i<midImageArray.count; i++) {
        UIButton *midImageBtn = [MyControll createButtonWithFrame:CGRectMake(i*vWIDTH/4, 20, vWIDTH/4, 40) bgImageName:nil imageName:midImageArray[i] title:nil selector:@selector(midImageBtnClick:) target:self];
        [midView addSubview:midImageBtn];
    }
}
-(void)midImageBtnClick:(UIButton *)sender
{
    
}
@end
