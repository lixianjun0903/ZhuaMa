//
//  TrendTongzhiViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TrendTongzhiViewController.h"
#import "TrendTongzhiTableViewCell.h"
#import "MJRefresh.h"
#import "TrendDetailViewController.h"
@interface TrendTongzhiViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    
    int mpage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation TrendTongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mpage = 0;
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"动态通知" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self createTableView];
    [self loadData];
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendTongzhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[TrendTongzhiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendDetailViewController *vc = [[TrendDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@topicnote?uid=%@&token=%@&limit=10&page=%d",SERVER_URL,uid,token,mpage+1];
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
        self.dataArray = [NSMutableArray arrayWithArray:array];
        mpage++;
        [_tableView reloadData];
    }
    else if(array.count == 0)
    {
        [self showMsg:@"没有数据"];
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
    _mDownManager = nil;
    _mDownManager.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
