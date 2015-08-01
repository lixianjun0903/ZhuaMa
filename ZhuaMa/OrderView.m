//
//  OrderView.m
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.delegate = self;
        _tableView.backgroundColor= [UIColor colorWithRed:0.87f green:0.87f blue:0.86f alpha:1.00f];
        _tableView.dataSource = self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}
-(void)loadData
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *key = @[@"距离最近",@"评分最高",@"待遇最高",@"最新发布"];
    NSArray *value = @[@"1",@"2",@"3",@"4"];
    for (int i = 0; i<4; i++) {
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
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"全城";
//}

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
    [_delegate selectOrder:self.dataArray[indexPath.row][@"key"] ID:self.dataArray[indexPath.row][@"value"]];
}
@end
