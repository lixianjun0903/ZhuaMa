//
//  MessageView.m
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MessageView.h"
#import "CheckMessageViewController.h"
@implementation MessageView

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
        mpage = 0;
        type = 1;
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
    MymessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MymessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        CheckMessageViewController *vc = [[CheckMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.name = self.dataArray[indexPath.row][@"name"];
        vc.tid = self.dataArray[indexPath.row][@"uid"];
        [_delegate.navigationController pushViewController:vc animated:YES];
       [self.dataArray removeObjectAtIndex:indexPath.row];
       [_tableView reloadData];
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
