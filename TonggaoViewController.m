//
//  TonggaoViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TonggaoViewController.h"
#import "AnnounceTableViewCell.h"
#import "FirstSectionTableViewCell.h"
#import "MJRefresh.h"
#import "SearchView.h"
#import "FaBuListViewController.h"
#import "AnDetailViewController.h"
#import "TongGaoDetailViewController.h"
#import "RaiseDetailViewController.h"
#import "LocationHandler.h"
@interface TonggaoViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,SearchDelegate>
{
    UITableView *_tableView;
    BOOL isFirstLoad;
    int mpage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    
    
    NSString *cityID;
    NSString *proID;
    NSString *typeID;
    NSString *subTypeID;
    NSString *orderID;
    NSString *whereKeyWord;
    NSString *lat;
    NSString *lng;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation TonggaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    mpage = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self backToNormal];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"通告" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    [self AddLeftImageBtn:[UIImage imageNamed:@"发布通告.png"] target:self action:@selector(announce)];
    [self AddRightImageBtn:[UIImage imageNamed:@"搜索.png"] target:self action:@selector(search)];
    
    [self createTableView];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
    [self updateplace];
    
}
-(void)updateplace
{
    [[LocationHandler getSharedInstance]setDelegate:self];
    [[LocationHandler getSharedInstance]startUpdating];
}
-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
//    [_delegate didFinishUpdate:self Long:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] Lat:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude]];
    
    lat =[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    lng =[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@"lat%@~~~lng%@",lat,lng);
//    [self loadData];
    if ([lat intValue]==0&&[lng intValue]==0) {
        
    }
    else{
        [self loadData];
        [[LocationHandler getSharedInstance]stopUpdating];
    }
}
-(void)didFailWithError:(NSError *)error
{
    [[LocationHandler getSharedInstance]stopUpdating];
    [self loadData];
}
-(void)backToNormal
{
    cityID = @"0";
    proID = @"0";
    typeID = @"0";
    subTypeID = @"0";
    orderID = @"4";
    whereKeyWord = @"";
//    lat = @"0";
//    lng = @"0";
}
-(void)announce
{
    FaBuListViewController *vc = [[FaBuListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)search
{
    SearchView *searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64+49)];
    searchView.delegate = self;
    searchView.tag = 1;
    [self.tabBarController.view addSubview:searchView];
}
-(void)search:(SearchView *)searchView Dic:(NSDictionary *)dic Flag:(int)flag
{
    mpage = 0;
    if (flag == 0) {
        [self backToNormal];
        [self loadData];
    }
    else if (flag == 1)
    {
        proID = [dic objectForKey:@"proID"];
        cityID = @"0";
        [self loadData];
    }
    else if (flag == 2)
    {
        proID = [dic objectForKey:@"proID"];
        cityID = [dic objectForKey:@"cityID"];
        [self loadData];
    }
    else if (flag == 3)
    {
        subTypeID = [dic objectForKey:@"subtypeID"];
        [self loadData];
    }
    else if (flag == 4)
    {
        orderID = [dic objectForKey:@"orderID"];
        [self loadData];
    }
    else if (flag == 6)
    {
        [self backToNormal];
        whereKeyWord = [dic objectForKey:@"keyword"];
        [self loadData];
    }
    SearchView *searchView1 = (SearchView *)[self.tabBarController.view viewWithTag:1];
    [searchView1 removeFromSuperview];
}
#pragma mark   创建tableview
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else
    {
       return self.dataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FirstSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDs"];
        if (!cell) {
            cell = [[FirstSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDs"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        [cell getAdData:isFirstLoad];
        [cell loadData:isFirstLoad];
        return cell;

    }
    else
    {
        AnnounceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!cell) {
            cell = [[AnnounceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic =self.dataArray[indexPath.row];
        [cell config:dic];
        return cell;
    }
    UITableViewCell *cell;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 460;
    }
    else
    {
        return 140;
    }
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    if ([dic[@"subtype"]isEqualToString:@"4"]) {
        TongGaoDetailViewController *vc = [[TongGaoDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([dic[@"subtype"]isEqualToString:@"5"])
    {
        RaiseDetailViewController *vc = [[RaiseDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        AnDetailViewController *vc = [[AnDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark  加载数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@indexlist?uid=%@&token=%@&pro=%@&city=%@&type=%@&subtype=%@&order=%@&where=%@&lat=%@&lng=%@&limit=20&page=%d",SERVER_URL,uid,token,proID,cityID,typeID,subTypeID,orderID,whereKeyWord,lat,lng,mpage+1];
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
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
    }
    else if(array.count == 0)
    {
        if (mpage == 0) {
            [self.dataArray removeAllObjects];
        }
        [self showMsg:@"没有数据"];
        [_tableView reloadData];
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
    }
}
-(void)delay
{
    isFirstLoad = NO;
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    [_header endRefreshing];
    [_footer endRefreshing];
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
        isFirstLoad = YES;
        [self updateplace];
        
    }
    else
    {
         [self updateplace];
    }
    
}
-(void)dealloc
{
    [_header free];
    [_footer free];
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
