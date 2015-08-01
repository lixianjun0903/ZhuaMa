//
//  recentFabuView.m
//  ZhuaMa
//
//  Created by xll on 15/1/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RecentFabuView.h"

@implementation RecentFabuView

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
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}
-(void)loadData
{
//    排序1距离最近2评分最高3待遇最高4最新发布
    self.dataArray = [NSMutableArray arrayWithCapacity:4];
    NSDictionary *dic4 = @{@"value":@"最新发布",@"id":@"4"};
    NSDictionary *dic1 = @{@"value":@"距离最近",@"id":@"1"};
    NSDictionary *dic2 = @{@"value":@"评分最高",@"id":@"2"};
    NSDictionary *dic3 = @{@"value":@"待遇最高",@"id":@"3"};
    [self.dataArray addObject:dic1];
    [self.dataArray addObject:dic2];
    [self.dataArray addObject:dic3];
    [self.dataArray addObject:dic4];
    [_tableView reloadData];
}
//-(void)loadData
//{
//    if (_mDownManager) {
//        return;
//    }
//    [self StartLoading];
//    NSString *urlstr = [NSString stringWithFormat:@"%@choiselist?type=2",SERVER_URL];
//    self.mDownManager= [[ImageDownManager alloc]init];
//    _mDownManager.delegate = self;
//    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
//    _mDownManager.OnImageFail = @selector(OnLoadFail:);
//    [_mDownManager GetImageByStr:urlstr];
//    
//}
//-(void)OnLoadFinish:(ImageDownManager *)sender
//{
//    NSString *resStr = sender.mWebStr;
//    NSArray *array = [resStr JSONValue];
//    [self Cancel];
//    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
//        NSLog(@"%@", array);
//        self.dataArray = [NSMutableArray arrayWithArray:array];
//        [_tableView reloadData];
//    }
//}
//- (void)OnLoadFail:(ImageDownManager *)sender {
//    [self Cancel];
//}
//- (void)Cancel {
//    [self StopLoading];
//    SAFE_CANCEL_ARC(self.mDownManager);
//}
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
    cell.textLabel.text = self.dataArray[indexPath.row][@"value"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate selectRecent:self.dataArray[indexPath.row][@"value"] ID:self.dataArray[indexPath.row][@"id"]];
}

@end
