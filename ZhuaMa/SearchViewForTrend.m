//
//  SearchViewForTrend.m
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SearchViewForTrend.h"

@implementation SearchViewForTrend

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
    UIImageView *navBar = [MyControll createImageViewWithFrame:CGRectMake(0, 20, vWIDTH, 44) imageName:@"1@2x.png"];
    navBar.userInteractionEnabled = YES;
    [self addSubview:navBar];
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(10, 5, 40, 34) bgImageName:nil imageName:@"38" title:nil selector:@selector(goBack1) target:self];
    [navBar addSubview:backBtn];
    
    textField = [MyControll createTextFieldWithFrame:CGRectMake(60, 8, vWIDTH-60-50, 30) text:nil placehold:@"  请输入你要查找的内容" font:14];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 5;
    textField.clipsToBounds = YES;
    [navBar addSubview:textField];
    
    UIButton *searchGo = [MyControll createButtonWithFrame:CGRectMake(vWIDTH - 50, 10, 40, 25) bgImageName:nil imageName:@"3" title:nil selector:@selector(searchGo) target:self];
    searchGo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [navBar addSubview:searchGo];
    
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 64, vWIDTH, vHEIGHT-64)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    
    
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [self removeFromSuperview];
}
-(void)goBack1
{
    [self removeFromSuperview];
}
-(void)searchGo
{

        [_delegate search:self SearchStr:textField.text Flag:1];
        [self removeFromSuperview];
    
}
@end
