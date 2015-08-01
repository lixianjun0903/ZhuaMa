//
//  PlaceSelectView.m
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PlaceSelectView.h"

@implementation PlaceSelectView

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
    self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    CityView *cityView = [[CityView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT/2)];
    cityView.center = CGPointMake(vWIDTH/2, vHEIGHT/2);
    cityView.delegate = self;
    cityView.tag = 2000;
    [cityView loadData];
    [self addSubview:cityView];
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate placeSelect:self Dic:nil Flag:0];
}
-(void)selectCity:(NSString *)cityName ID:(NSString *)id
{
    pro = cityName;
    proID = id;
    if([pro isEqualToString:@"#全部省份"])
    {
        [self.dataDic setObject:pro forKey:@"proName"];
        [self.dataDic setObject:proID forKey:@"proID"];
        [_delegate placeSelect:self Dic:self.dataDic Flag:1];
    }
    CityView *cityView = (CityView *)[self viewWithTag:2000];
    [cityView removeFromSuperview];
    
    CityDetailView *cityDetailView = [[CityDetailView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT/2)];
    cityDetailView.center = CGPointMake(vWIDTH/2, vHEIGHT/2);
    cityDetailView.tag = 2001;
    cityDetailView.delegate = self;
    [cityDetailView loadData:proID];
    [self addSubview:cityDetailView];
}
-(void)selectCityDetail:(NSString *)cityName ID:(NSString *)id
{
    city = cityName;
    cityID = id;
    [self.dataDic setObject:proID forKey:@"proID"];
    [self.dataDic setObject:pro forKey:@"pro"];
    [self.dataDic setObject:cityID forKey:@"cityID"];
    [self.dataDic setObject:city forKey:@"city"];
    [_delegate placeSelect:self Dic:self.dataDic Flag:2];
    
    CityDetailView *cityDetailView = (CityDetailView *)[self viewWithTag:2001];
    [cityDetailView removeFromSuperview];
}
@end
