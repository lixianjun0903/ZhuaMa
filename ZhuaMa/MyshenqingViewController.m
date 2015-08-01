//
//  MyshenqingViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MyshenqingViewController.h"
#import "MyshenqingTableViewCell.h"
#import "MytonggaoViewController.h"
#import "MytgDetailViewController.h"
#import "MJRefresh.h"
@interface MyshenqingViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIImageView *navView;
    UITableView *_tableView;
    UIImageView *topNav;
    
//    int mpage;
//    MJRefreshHeaderView *_header;
//    MJRefreshFooterView *_footer;
    
    int type;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation MyshenqingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
//    mpage = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self createNav];
    [self createTopNav];
    [self createTableView];
//    _header = [MJRefreshHeaderView header];
//    _header.scrollView = _tableView;
//    _header.delegate = self;
//    
//    _footer = [MJRefreshFooterView footer];
//    _footer.scrollView = _tableView;
//    _footer.delegate = self;

    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)GoBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark  上面导航topNav
-(void)createTopNav
{
    topNav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    topNav.image = [UIImage imageNamed:@"7"];
    topNav.userInteractionEnabled = YES;
    [self.view addSubview:topNav];
    
    UIButton *yishenqingBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH/3, 40) bgImageName:nil imageName:nil title:@"已申请" selector:@selector(detailBtn:) target:self];
    [yishenqingBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    yishenqingBtn.tag = 10;
    yishenqingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    yishenqingBtn.selected = YES;
    [topNav addSubview:yishenqingBtn];
    UIButton *yijujueBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/3*2, 0, WIDTH/3, 40) bgImageName:nil imageName:nil title:@"已拒绝" selector:@selector(detailBtn:) target:self];
    [yijujueBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    yijujueBtn.tag = 12;
    yijujueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [topNav addSubview:yijujueBtn];
    
    UIButton *yitongguoBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/3, 0, WIDTH/3, 40) bgImageName:nil imageName:nil title:@"已通过" selector:@selector(detailBtn:) target:self];
    [yitongguoBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    yitongguoBtn.tag = 11;
    yitongguoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [topNav addSubview:yitongguoBtn];

    
    UIImageView *bottomLine = [MyControll createImageViewWithFrame:CGRectMake((WIDTH/3 - 80)/2, 37, 80, 3) imageName:@"46"];
    bottomLine.tag = 15;
    [topNav addSubview:bottomLine];
    
}
-(void)detailBtn:(UIButton *)sender
{
    int index = (int)sender.tag -10;
    if (type == index) {
        return;
    }
    else
    {
        type =index;
        [self.dataArray removeAllObjects];
        [self loadData];
    }
    NSLog(@"%d",index);
    UIButton *btn0 = (UIButton *)[topNav viewWithTag:10];
    UIButton *btn1 = (UIButton *)[topNav viewWithTag:11];
    UIButton *btn2 = (UIButton *)[topNav viewWithTag:12];
    NSArray *tempArray = @[btn0,btn1,btn2];
    for (UIButton *btn in tempArray) {
        if (btn.tag - 10 == index) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    UIImageView *bottomLine = (UIImageView *)[topNav viewWithTag:15];
    [UIView animateWithDuration:0.3 animations:^{
        bottomLine.frame = CGRectMake(WIDTH/3 * index + (WIDTH/3 - 80)/2, 37, 80, 3);
    }];
    
}


-(void)createNav
{
    navView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, 120, 30) imageName:@"y"];
    UIButton *btn1= [MyControll createButtonWithFrame:CGRectMake(10, 0, 50, 30) bgImageName:nil imageName:nil title:@"申请" selector:@selector(myShenqing:) target:self];
    btn1.tag = 2;
    btn1.selected = YES;
    
    //    [btn1 setImage:[UIImage imageNamed:@"<#string#>"] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIButton *btn2 = [MyControll createButtonWithFrame:CGRectMake(70, 0, 50, 30) bgImageName:nil imageName:nil title:@"通告" selector:@selector(myTonggao:) target:self];
    btn2.tag = 1;
    btn2.selected = NO;
    //    [btn2 setImage:[UIImage imageNamed:@"<#string#>"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [navView addSubview:btn1];
    [navView addSubview:btn2];
    self.navigationItem.titleView = navView;
}
-(void)myShenqing:(UIButton *)sender
{
    sender.selected = YES;
    UIButton *btn = (UIButton *)[navView viewWithTag:1];
    btn.selected = NO;
    navView.image = [UIImage imageNamed:@"y"];
}
-(void)myTonggao:(UIButton *)sender
{
    sender.selected = YES;
    UIButton *btn = (UIButton *)[navView viewWithTag:2];
    btn.selected = NO;
    navView.image = [UIImage imageNamed:@"z"];
    MytonggaoViewController *vc = [[MytonggaoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 40-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
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
    MyshenqingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyshenqingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MytgDetailViewController *vc = [[MytgDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark   请求数据，加载数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@myannouncement?uid=%@&token=%@&flag=%d",SERVER_URL,uid,token,type];
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
//        if (mpage == 0) {
//            [self.dataArray removeAllObjects];
//        }
//        [self.dataArray addObjectsFromArray:array];
//        mpage++;
//        [_tableView reloadData];
//    }
//    else if(array.count == 0)
//    {
//        [self showMsg:@"没有数据"];
//    }
        [self.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    }
    else
    {
        [self showMsg:@"没有数据"];
        [_tableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
//    [_header endRefreshing];
//    [_footer endRefreshing];
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark - 数据下拉刷新和上拉加载更多
//刷新
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    //如果是下拉刷新
//    if(refreshView == _header)
//    {
//        NSLog(@"refreshView == _header");
//        mpage = 0;
//        [self loadData];
//        
//    }
//    else
//    {
//        [self loadData];
//    }
//    
//}
- (void)didReceiveMemoryWarning
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
