//
//  EduSelectView.m
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "EduSelectView.h"

@implementation EduSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [self removeFromSuperview];
}
-(void)makeUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT/2)];
    _tableView.center = CGPointMake(vWIDTH/2, vHEIGHT/2);
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor= [UIColor colorWithRed:0.87f green:0.87f blue:0.86f alpha:1.00f];
    _tableView.dataSource = self;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}
-(void)loadData
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *key = @[@"专科",@"本科",@"硕士研究生",@"博士",@"博士后"];
    NSArray *value = @[@"1",@"2",@"3",@"4",@"5"];
    for (int i = 0; i<key.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:key[i] forKey:@"key"];
        [dic setObject:value[i] forKey:@"value"];
        [self.dataArray addObject:dic];
    }
    [_tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(0, 0, vWIDTH, 40) title:self.dataArray[indexPath.row][@"key"] font:15];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    cell.backgroundColor =[UIColor colorWithRed:0.87f green:0.87f blue:0.86f alpha:1.00f];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate selectEdu:self.dataArray[indexPath.row][@"key"] ID:self.dataArray[indexPath.row][@"value"]];
    [self removeFromSuperview];
}
@end
