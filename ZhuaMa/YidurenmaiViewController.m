//
//  YidurenmaiViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "YidurenmaiViewController.h"
#import "RenmaiTableViewCell.h"
#import "RenmaiDetailViewController.h"
#import "MJRefresh.h"
#import "UploudContact.h"
#import "SearchViewForTrend.h"
@interface YidurenmaiViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,UIAlertViewDelegate,UploadContactDelegate,SearchTrendDelegate>
{
    UITableView *_tableView;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    int mpage;
    int type;
    NSString *keyWord;
    UploudContact *con;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation YidurenmaiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    keyWord = @"";
    type = 1;
    mpage = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"一度人脉" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self AddRightImageBtn:[UIImage imageNamed:@"搜索.png"] target:self action:@selector(search)];
    [self createTableView];
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *isUpload = [user objectForKey:@"upload"];
    if ([isUpload isEqualToString:@"1"]) {
        [self loadData];
    }
    else
    {
        [self upLoadContact];
    }
    
}
-(void)upLoadContact
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你没有同步通讯录,无法匹配好友人脉，是否同步？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        con = [[UploudContact alloc]initWithFrame:CGRectZero];
        con.delegate = self;
    }
    else
    {
        [self isNotAllowedAccess];
    }
}
-(void)didFailLoad
{
    
}
-(void)didFinishLoad
{
    [self loadData];
}
-(void)isNotAllowedAccess
{
    
}
-(void)search
{
    SearchViewForTrend *searchView = [[SearchViewForTrend alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64+49)];
    searchView.delegate = self;
    [self.tabBarController.view addSubview:searchView];
}
-(void)search:(SearchViewForTrend *)searchViewForTrend SearchStr:(NSString *)str Flag:(int)flag
{
    keyWord = str;
    mpage = 0;
    [self loadData];
}

#pragma mark   创建tableview
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RenmaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[RenmaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    cell.delegate = self;
    [cell config:self.dataArray[indexPath.row] type:0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
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
    NSString *urlstr = [NSString stringWithFormat:@"%@conanctlist?uid=%@&token=%@&type=1&limit=10&page=%d&where=%@",SERVER_URL,uid,token,mpage+1,keyWord];
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
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
