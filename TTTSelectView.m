//
//  TTTSelectView.m
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TTTSelectView.h"

@implementation TTTSelectView

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
    self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.backgroundColor = [UIColor clearColor];
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
   
}
-(void)StartGetData:(int)typeNum
{
    TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT/2)];
    typeView.center = CGPointMake(vWIDTH/2, vHEIGHT/2);
    typeView.delegate = self;
    typeView.tag = 2000;
    [typeView loadData:typeNum];
    [self addSubview:typeView];
}
-(void)selectType:(NSString *)type ID:(NSString *)id
{
    [self.dataDic setObject:type forKey:@"subtypeName"];
    [self.dataDic setObject:id forKey:@"subtypeID"];
    [_delegate TTTSelect:self Dic:self.dataDic Flag:1];
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate TTTSelect:self Dic:nil Flag:2];
}
@end
