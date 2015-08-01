//
//  HaoyoushenqingView.m
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "HaoyoushenqingView.h"
#import "RenmaiDetailViewController.h"
@implementation HaoyoushenqingView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mpage = 0;
        type = 2;
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        
        [self createTableView];
        _header = [MJRefreshHeaderView header];
        _header.scrollView = _tableView;
        _header.delegate = self;
        
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = _tableView;
        _footer.delegate = self;
        [self loadData];
        
    }
    return self;
}

#pragma mark  主UI

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _tableView.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.opaque = NO;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HaoyouShenqingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[HaoyouShenqingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.accessoryView.subviews) {
        [view removeFromSuperview];
    }
    cell.accessoryView = nil;
    UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 40) bgImageName:nil imageName:@"jieshou" title:nil selector:@selector(btnClick:) target:self];
    btn.tag = indexPath.row;
    cell.accessoryView = btn;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
    
    
}
-(void)btnClick:(UIButton *)sender
{
    
    int index = (int)sender.tag;
    rowNum = index;
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSDictionary *dic = self.dataArray[index];
    
    //    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@addfriend?uid=%@&token=%@&type=1&tid=%@",SERVER_URL,uid,token,dic[@"id"]];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];

}
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"同意添加好友成功"];
            NSDictionary *dic = self.dataArray[rowNum];
            [self.dataArray removeObject:dic];
            [_tableView reloadData];
        }
        else
        {
            [self showMsg:@"同意添加好友失败"];
        }
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = self.dataArray[indexPath.row][@"id"];
    [_delegate.navigationController pushViewController:vc animated:YES];
}
#pragma mark  获取数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@mymessagelist?uid=%@&token=%@&type=%d&limit=10&page=%d",SERVER_URL,uid,token,type,mpage+1];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        NSLog(@"%@", array);
        if (mpage == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:array];
        mpage++;
        [_tableView reloadData];
    }
    else if(array.count == 0)
    {
        [self showMsg:@"没有数据"];
        [_tableView reloadData];
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [_header endRefreshing];
    [_footer endRefreshing];
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark - 数据下拉刷新和上拉加载更多
//刷新
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //如果是下拉刷新
    if(refreshView == _header)
    {
        NSLog(@"refreshView == _header");
        mpage = 0;
        [self loadData];
        
    }
    else
    {
        [self loadData];
    }
    
}
-(void)dealloc
{
    _header.scrollView = nil;
    _footer.scrollView = nil;
}

@end
