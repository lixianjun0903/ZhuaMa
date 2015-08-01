//
//  WorkInfoViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/19.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "WorkInfoViewController.h"
#import "WorkInfoTableViewCell.h"
#import "MJRefresh.h"
#import "WorkInfoDetailViewController.h"
@interface WorkInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    
    int mpage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    UIButton *addBtn;
    UIButton *addBtn_right;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation WorkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mpage = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.94f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 100, 35) title:@"工作经历" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    addBtn_right = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"+" selector:@selector(addWorkInfo) target:self];
    addBtn_right.titleLabel.font = [UIFont systemFontOfSize:20];
    [addBtn_right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn_right];
    
    [self makeUI];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"workInfoListRefresh" object:nil];
}
-(void)refreshData
{
    mpage =0;
    [self loadData];
}
-(void)addWorkInfo
{
    WorkInfoDetailViewController *vc = [[WorkInfoDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)makeUI
{
    addBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-160)/2, 80, 160, 40) bgImageName:nil imageName:@"tianjai" title:nil selector:@selector(addWorkInfo) target:self];
    [self.view addSubview:addBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.93f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        addBtn.hidden = NO;
        _tableView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else{
        _tableView.hidden = NO;
        addBtn.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn_right];
    }
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[WorkInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkInfoDetailViewController *vc = [[WorkInfoDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type =1;
    vc.dataDic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  加载数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@worklist?uid=%@&token=%@&limit=10&page=%d",SERVER_URL,uid,token,mpage+1];
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
    if (array&&[array isKindOfClass:[array class]]&&array.count>0) {
        if (mpage == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:array];
        mpage++;
        [_tableView reloadData];
    }
    else
    {
        [_tableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _header.scrollView = nil;
    _footer.scrollView = nil;
    self.mDownManager.delegate = nil;
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
