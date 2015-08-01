//
//  SearchView.m
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

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
    UIImageView *navBar = [MyControll createImageViewWithFrame:CGRectMake(0, 20, vWIDTH, 44) imageName:@"1@2x.png"];
    navBar.userInteractionEnabled = YES;
    [self addSubview:navBar];
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(10, 5, 40, 34) bgImageName:nil imageName:@"38" title:nil selector:@selector(goBack1) target:self];
    [navBar addSubview:backBtn];
    
    textField = [MyControll createTextFieldWithFrame:CGRectMake(60, 8, vWIDTH-60-90, 30) text:nil placehold:@"  请输入你要查找的内容" font:14];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 5;
    textField.clipsToBounds = YES;
    [navBar addSubview:textField];
    
    UIButton *xialaBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH-50, 5, 40, 34) bgImageName:nil imageName:@"53" title:nil selector:@selector(xialaClick) target:self];
    [navBar addSubview:xialaBtn];
    
    UIButton *searchGo = [MyControll createButtonWithFrame:CGRectMake(vWIDTH - 85, 10, 37, 25) bgImageName:nil imageName:@"3" title:nil selector:@selector(searchGo) target:self];
    searchGo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [navBar addSubview:searchGo];
    
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 64, vWIDTH, vHEIGHT-64)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
   
    
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate search:self Dic:nil Flag:5];
}
-(void)goBack1
{
    [_delegate search:self Dic:nil Flag:5];
}
-(void)searchGo
{
    if (textField.text.length==0) {
        [self showMsg:@"搜索内容不能为空"];
        return;
    }
    else
    {
        [self.dataDic setObject:textField.text forKey:@"keyword"];
        [_delegate search:self Dic:self.dataDic Flag:6];
    }
}
-(void)xialaClick
{
    if (rightBgView) {
        return;
    }
    rightBgView = [MyControll createViewWithFrame:CGRectMake(vWIDTH/2, 64, vWIDTH/2, 0)];
    rightBgView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    [self addSubview:rightBgView];
    
    NSArray *titleArray = @[@"全部",@"城市",@"类型",@"最新发布"];
    
    [UIView animateWithDuration:0.1 animations:^{
        for (int i = 0; i<4; i++) {
            rightBgView.frame = CGRectMake(vWIDTH/2, 64, vWIDTH/2, 160);
            UIButton * rightBtn = [MyControll createButtonWithFrame:CGRectMake(0, i*40, vWIDTH/2, 40) bgImageName:nil imageName:nil title:titleArray[i] selector:@selector(rightClick:) target:self];
            rightBtn.tag = 100+i;
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [rightBgView addSubview:rightBtn];
            
            if (i != 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, i*40, vWIDTH/2-20, 1)];
                line.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f];
                [rightBgView addSubview:line];
                
                UIImageView *jiantou = [MyControll createImageViewWithFrame:CGRectMake(10, i*40, 8, 40) imageName:@"n5@2x"];
                jiantou.contentMode = UIViewContentModeScaleAspectFit;
                [rightBgView addSubview:jiantou];
            }
            
        }
    }];
}
-(void)rightClick:(UIButton *)sender
{
    CityView *cityView = (CityView *)[self viewWithTag:2000];
    [cityView removeFromSuperview];
    CityDetailView *cityDetailView = (CityDetailView *)[self viewWithTag:2001];
    [cityDetailView removeFromSuperview];
    TypeView *typeView = (TypeView *)[self viewWithTag:2002];
    [typeView removeFromSuperview];
    OrderView *orderView = (OrderView *)[self viewWithTag:2003];
    [orderView removeFromSuperview];
    
    int index = (int)sender.tag-100;
    if (index == 1) {
        CityView *cityView = [[CityView alloc]initWithFrame:CGRectMake(0, 64, vWIDTH/2, 160)];
        cityView.tag = 2000;
        cityView.delegate = self;
        [cityView loadData];
        [self addSubview:cityView];
    }
    else if (index == 0)
    {
        [_delegate search:self Dic:nil Flag:0];
        [self removeXiaLaView];
    }
    else if (index == 2)
    {
        TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 64, vWIDTH/2, 160)];
        typeView.delegate = self;
        typeView.tag = 2002;
        [typeView loadData:10];
        [self addSubview:typeView];
    }
    else if (index == 3)
    {
        OrderView *orderView = [[OrderView alloc]initWithFrame:CGRectMake(0, 64, vWIDTH/2, 160)];
        orderView.delegate = self;
        orderView.tag = 2003;
        [orderView loadData];
        [self addSubview:orderView];
    }
}
-(void)selectCity:(NSString *)proName ID:(NSString *)id
{
    pro = proName;
    proID = id;
    
    CityView *cityView = (CityView *)[self viewWithTag:2000];
    [cityView removeFromSuperview];

    if([proName isEqualToString:@"#全部省份"])
    {
        pro  = @"全部城市";
        proID = @"0";
        
        
        [self.dataDic setObject:proID forKey:@"proID"];
        [self.dataDic setObject:pro forKey:@"pro"];
        [_delegate search:self Dic:self.dataDic Flag:1];
        [self removeXiaLaView];
    }
    
    
    
    CityDetailView *cityDetailView = [[CityDetailView alloc]initWithFrame:CGRectMake(0, 64, vWIDTH/2, 160)];
    cityDetailView.tag = 2001;
    cityDetailView.delegate = self;
    [cityDetailView loadData:proID];
    [self addSubview:cityDetailView];
}
-(void)selectCityDetail:(NSString *)cityName ID:(NSString *)id
{
    cityID = id;
    city =cityName;
    [self.dataDic setObject:proID forKey:@"proID"];
    [self.dataDic setObject:pro forKey:@"pro"];
    [self.dataDic setObject:cityID forKey:@"cityID"];
    [self.dataDic setObject:city forKey:@"city"];
    [_delegate search:self Dic:self.dataDic Flag:2];
    [self removeXiaLaView];
}
-(void)selectType:(NSString *)type ID:(NSString *)id
{
    [self.dataDic setObject:type forKey:@"subtypeName"];
    [self.dataDic setObject:id forKey:@"subtypeID"];
    [_delegate search:self Dic:self.dataDic Flag:3];
    [self removeXiaLaView];
}
-(void)selectOrder:(NSString *)orderName ID:(NSString *)id
{
    [self.dataDic setObject:orderName forKey:@"orderName"];
    [self.dataDic setObject:id forKey:@"orderID"];
    [_delegate search:self Dic:self.dataDic Flag:4];
    [self removeXiaLaView];
}
-(void)removeXiaLaView
{
    [rightBgView removeFromSuperview];
    
    CityView *cityView = (CityView *)[self viewWithTag:2000];
    [cityView removeFromSuperview];
    CityDetailView *cityDetailView = (CityDetailView *)[self viewWithTag:2001];
    [cityDetailView removeFromSuperview];
    TypeView *typeView = (TypeView *)[self viewWithTag:2002];
    [typeView removeFromSuperview];
    OrderView *orderView = (OrderView *)[self viewWithTag:2003];
    [orderView removeFromSuperview];
}
@end
