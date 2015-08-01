//
//  AnnounceViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "AnnounceViewController.h"
#import "AnnounceTableViewCell.h"
#import "AnDetailViewController.h"
#import "PressAnnounceViewController.h"
#import "CityView.h"
#import "CityDetailView.h"
#import "TypeView.h"
#import "RecentFabuView.h"
#import "ImageDownManager.h"
#import "MJRefresh.h"
#import "xllAppDelegate.h"
#import "FirstPageViewController.h"
@interface AnnounceViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CitySelectDelegate,CityDetailSelectDelegate,MJRefreshBaseViewDelegate,TypeSelectDelegate,RecentSelectDelegate>
{
    UIPageControl *mPageCtrl;
    UITableView *_tableView;
    UIImageView *topImageview;
    NSString *cityName;
    NSString *cityID;
    NSString *proID;
    NSString *type;
    NSString *order;
    
    int mpage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSString *keyWord;
    
    UIView *xiaLaView;
    
    NSString *subtype;
    NSString *small;
    NSString *big;
    
    int flag;//搜索类型判断标志
    BOOL isDingweiOpen;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)NSMutableArray *adArray;
@end

@implementation AnnounceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    _mDownManager.delegate = nil;
    _secDownManager.delegate = nil;
    _header.scrollView = nil;
    _footer.scrollView = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isDingweiOpen = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"通告" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    [self AddLeftImageBtn:[UIImage imageNamed:@"发布通告.png"] target:self action:@selector(announce)];
    [self AddRightImageBtn:[UIImage imageNamed:@"搜索.png"] target:self action:@selector(search)];
    
    [self createTopNav];
    [self createTableView];
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
    [self backToBegin];
    [self loadData];
    [self getAdData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:@"fabuSuccess" object:nil];
}
-(void)backToBegin
{
    order = @"4";
    type = @"0";
    cityID = @"0";
    proID = @"0";
    keyWord = @"";
    mpage = 0;
    flag = 0;
}
-(void)refreshUI
{
    [self backToBegin];
    [self loadData];
}
-(void)announce
{
    PressAnnounceViewController *vc = [[PressAnnounceViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)search
{
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT + 100)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 10000;
    [self.tabBarController.view addSubview:view];
    
  UIImageView *searchView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 44) imageName:@"1"];
    searchView.tag = 120;
    searchView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar addSubview:searchView];
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 60, 40) bgImageName:nil imageName:@"38" title:nil selector:@selector(backToNormal) target:self];
    [searchView addSubview:backBtn];
    UITextField * searchTx = [MyControll createTextFieldWithFrame:CGRectMake(70,5, WIDTH - 60 - 70, 30) text:nil placehold:@"  请输入你要查找的内容" font:15];
    [searchTx becomeFirstResponder];
    searchTx.tag = 98765;
    searchTx.layer.cornerRadius = 5;
    searchTx.clipsToBounds = YES;
    searchTx.backgroundColor = [UIColor whiteColor];
    searchTx.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:searchTx];
    
    UIButton *searchGo = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 50, 0, 40, 40) bgImageName:nil imageName:@"53" title:nil selector:@selector(searchGo) target:self];
    [searchView addSubview:searchGo];
}
-(void)searchGo
{
    UIView *view = [self.tabBarController.view viewWithTag:10000];
    if (xiaLaView) {
        return;
    }
    xiaLaView = [MyControll createViewWithFrame:CGRectMake(WIDTH, 0, 0, 0)];
    xiaLaView.backgroundColor = [UIColor whiteColor];
    NSArray *titleArray = @[@"全部不限",@"性别",@"年龄段",@"身高范围(cm)",@"体重范围(kg)"];
    [view addSubview:xiaLaView];
    [UIView animateWithDuration:0.5 animations:^{
        xiaLaView.frame= CGRectMake(WIDTH - 100, 0, 100, 200);
        for (int i = 0; i<titleArray.count; i++) {
            UIButton *choseBtn = [MyControll createButtonWithFrame:CGRectMake(0, i*40, 100, 40) bgImageName:nil imageName:nil title:titleArray[i] selector:@selector(choseClick:) target:self];
            choseBtn.tag = 300+i;
            [choseBtn setTitleColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f] forState:UIControlStateNormal];
            [choseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [choseBtn setBackgroundImage:[UIImage imageNamed:@"huitiao"] forState:UIControlStateSelected];
            [choseBtn setBackgroundImage:[UIImage imageNamed:@"baitiao"] forState:UIControlStateNormal];
            choseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [choseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [xiaLaView addSubview:choseBtn];
        }
    }];
    
    
}
-(void)choseClick:(UIButton *)sender
{
    int index = (int)sender.tag - 300;
    for (int i = 0; i<5; i++) {
        UIButton *choseBtn = (UIButton *)[xiaLaView viewWithTag:300+i];
        if (choseBtn.tag == sender.tag) {
            choseBtn.selected = YES;
        }
        else
        {
            choseBtn.selected = NO;
        }
    }
    
    if (index != 0) {
        UIView *view = [self.tabBarController.view viewWithTag:10000];
        UIView *ceLaView = [view viewWithTag:400];
        if (!ceLaView) {
            ceLaView = [MyControll createViewWithFrame:CGRectMake(WIDTH-100, 0, 0, 200)];
            ceLaView.tag = 400;
            ceLaView.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.00f];
            [view addSubview:ceLaView];
            [UIView animateWithDuration:0.5 animations:^{
                ceLaView.frame = CGRectMake(0, 0, WIDTH-100, 200);
            }];
        }
        for (UIView *v in ceLaView.subviews) {
            [v removeFromSuperview];
        }
        float height = 200/6;
        if (index == 1) {
            NSArray *sexArray = @[@"男",@"女",@"不限"];
            for (int i = 0; i<3; i++) {
                UIButton *sexBtn = [MyControll createButtonWithFrame:CGRectMake(0, i*40, WIDTH-100, 40) bgImageName:nil imageName:nil title:sexArray[i] selector:@selector(sexClick:) target:self];
                [sexBtn setTitleColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f] forState:UIControlStateNormal];
                sexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                sexBtn.tag = 500+i;
                [ceLaView addSubview:sexBtn];
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*40, WIDTH-100, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
                [ceLaView addSubview:line];
            }
            
        }
        else if (index == 2)
        {
            NSArray *sexArray = @[@"不限",@"0-5(婴幼儿)",@"6-11(少儿)",@"12-17(青少年)",@"18-29(青年)",@"30-45(中年)"];
            for (int i = 0; i<6; i++) {
                UIButton *sexBtn = [MyControll createButtonWithFrame:CGRectMake(0, i*height, WIDTH-100, height) bgImageName:nil imageName:nil title:sexArray[i] selector:@selector(sexClick:) target:self];
                [sexBtn setTitleColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f] forState:UIControlStateNormal];
                sexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                sexBtn.tag = 503+i;
                [ceLaView addSubview:sexBtn];
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*height, WIDTH-100, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
                [ceLaView addSubview:line];
            }
            
        }
        else if (index == 3)
        {
            NSArray *sexArray = @[@"不限",@"160以下",@"160-170",@"170-180",@"180-190",@"190以上"];
            for (int i = 0; i<6; i++) {
                UIButton *sexBtn = [MyControll createButtonWithFrame:CGRectMake(0, i*height, WIDTH-100, height) bgImageName:nil imageName:nil title:sexArray[i] selector:@selector(sexClick:) target:self];
                [sexBtn setTitleColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f] forState:UIControlStateNormal];
                sexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                sexBtn.tag = 509+i;
                [ceLaView addSubview:sexBtn];
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*height, WIDTH-100, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
                [ceLaView addSubview:line];
            }
            
        }
        else if (index == 4)
        {
            NSArray *sexArray = @[@"不限",@"40以下",@"40-50",@"50-60",@"60-70",@"70以上"];
            for (int i = 0; i<6; i++) {
                UIButton *sexBtn = [MyControll createButtonWithFrame:CGRectMake(0, i*height, WIDTH-100, height) bgImageName:nil imageName:nil title:sexArray[i] selector:@selector(sexClick:) target:self];
                [sexBtn setTitleColor:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f] forState:UIControlStateNormal];
                sexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                sexBtn.tag = 515+i;
                [ceLaView addSubview:sexBtn];
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*height, WIDTH-100, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
                [ceLaView addSubview:line];
            }
            
        }

    }
    else if (index == 0) {
        [self backToBegin];
        [self loadData];
        [self backToNormal];
    }
}
-(void)sexClick:(UIButton *)sender
{
    [self backToBegin];
    flag = 1;
    int index = (int)sender.tag - 500;
    if (sender.tag ==500) {
        subtype = @"1";
        small = @"2";
        big = @"";
    }
    else  if (sender.tag ==501) {
        subtype = @"1";
        small = @"1";
        big = @"";
    }
    else  if (sender.tag ==502) {
        subtype = @"1";
        small = @"0";
         big = @"";
    }
    else
    {
        if (sender.tag >502&&sender.tag<509) {
            subtype = @"2";
        }
        else if (sender.tag >508&&sender.tag<515)
        {
            subtype =@"3";
        }
        else if(sender.tag >514&&sender.tag<211)
        {
            subtype = @"4";
        }
        NSString *name = [NSString stringWithFormat:@"sheng.plist"];
        NSString *path = [[NSBundle mainBundle] resourcePath];
        path = [path stringByAppendingPathComponent:name];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSDictionary *dic = array[index-3];
        small = dic[@"low"];
        big = dic[@"higt"];
    }
    [self loadData];
    [self backToNormal];
}
-(void)backToNormal
{
    UIImageView *searchView = (UIImageView *)[self.navigationController.navigationBar viewWithTag:120];
    for (UIView *v in searchView.subviews) {
        [v removeFromSuperview];
    }
    [searchView removeFromSuperview];
    searchView = nil;
    
    UIView *view = [self.tabBarController.view viewWithTag:10000];
    for (UIView *v  in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview ];
    xiaLaView = nil;
    view = nil;
}
#pragma mark  上面导航topNav
-(void)createTopNav
{
    topImageview = [MyControll createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 40) imageName:@"7@2x.png"];
    topImageview.userInteractionEnabled = YES;
    [self.view addSubview:topImageview];
    NSArray *picArray = @[@"8@2x",@"9@2x",@"10@2x"];
    NSArray *titleArray = @[@"所有城市",@"所有类型",@"最新发布"];
    for (int i = 0; i<picArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3 * i, 0, WIDTH/3, 40)];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topImageview addSubview:btn];
        
        UIImageView *imageview = [MyControll createImageViewWithFrame:CGRectMake(10 + WIDTH/3 *i, 0, 12, 40) imageName:picArray[i]];
        imageview.tag = 20+i;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [topImageview addSubview:imageview];
        
        UIImageView *jiandou = [MyControll createImageViewWithFrame:CGRectMake(WIDTH/3 *(i+1)-25, 0, 12, 40) imageName:@"11@2x"];
        jiandou.tag = 30+i;
        jiandou.contentMode = UIViewContentModeScaleAspectFit;
        [topImageview addSubview:jiandou];
        
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(22 + WIDTH/3 * i, 0, WIDTH/3-22-25, 40) title:titleArray[i] font:12];
        label.tag = 40+i;
        label.textAlignment =NSTextAlignmentCenter;
        [topImageview addSubview:label];

    }
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag - 10;
    NSLog(@"%d",index);
    
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64 + 49)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 100;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.tabBarController.view addSubview:view];
    
    if (index == 0) {
        
        CityView *cityView = [[CityView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, view.frame.size.height - 90 - 60)];
        cityView.tag = 2000;
        cityView.delegate = self;
        [cityView loadData];
        [self.tabBarController.view addSubview:cityView];
    }
    else if (index == 1)
    {
        TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 90, WIDTH,280)];
        typeView.tag = 2002;
        typeView.delegate = self;
        [typeView loadData:10];
        [self.tabBarController.view addSubview:typeView];
    }
    else if (index ==2)
    {
        RecentFabuView *typeView = [[RecentFabuView alloc]initWithFrame:CGRectMake(0, 150, WIDTH,160)];
        typeView.tag = 2003;
        [typeView loadData];
        typeView.delegate = self;
        [self.tabBarController.view addSubview:typeView];
    }
    
}
-(void)tap:(UIGestureRecognizer *)sendre
{
    UIView *view = [self.tabBarController.view viewWithTag:100];

    [view removeFromSuperview ];
    view = nil;
    CityView *city = (CityView *)[self.tabBarController.view viewWithTag:2000];
    [city removeFromSuperview];
    CityDetailView *cityDetailView = (CityDetailView *)[self.tabBarController.view viewWithTag:2001];
    [cityDetailView removeFromSuperview];
    TypeView *typeView = (TypeView *)[self.tabBarController.view viewWithTag:2002];
    [typeView removeFromSuperview];
    RecentFabuView *recentView = (RecentFabuView *)[self.tabBarController.view viewWithTag:2003];
    [recentView removeFromSuperview];
}
#pragma mark  主界面UI
-(void)makeTopSC
{
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -130, WIDTH, 120)];
    sc.delegate = self;
    sc.pagingEnabled = YES;
    sc.showsHorizontalScrollIndicator = NO;
    [_tableView addSubview:sc];
    for (int i = 0; i < self.adArray.count; i ++) {
        UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, 120) imageName:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"image"]]];
        [sc addSubview:imageView];
    }
    sc.contentSize = CGSizeMake(WIDTH*self.adArray.count, sc.frame.size.height);
    mPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, sc.frame.origin.y+sc.frame.size.height-30, sc.frame.size.width, 20)];
    mPageCtrl.numberOfPages = self.adArray.count;
    mPageCtrl.currentPage = 0;
    [_tableView addSubview:mPageCtrl];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _tableView) {
        mPageCtrl.currentPage = (scrollView.contentOffset.x+5)/scrollView.frame.size.width;
    }
    
}
#pragma mark   创建tableview
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 40 + 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.opaque = NO;
    _tableView.contentInset = UIEdgeInsetsMake(130, 0, 49, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnDetailViewController *vc = [[AnDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"id"];
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
    NSString *dingwei = [user objectForKey:@"isDingwei"];
    NSString *lat;
    NSString *longt;
    if ([dingwei isEqualToString:@"OK"]) {
        lat = [user objectForKey:@"latitude"];
        longt = [user objectForKey:@"longitude"];
    }
    else if ([dingwei isEqualToString:@"NO"])
    {
        lat = @"";
        longt = @"";
    }
    [self StartLoading];
    NSString *urlstr;
    if (flag == 0) {
        urlstr = [NSString stringWithFormat:@"%@indexlist?uid=%@&token=%@&city=%@&type=%@&order=%@&limit=10&page=%d&pro=%@&where=%@&lat=%@&lng=%@",SERVER_URL,uid,token,cityID,type,order,mpage+1,proID,keyWord,lat,longt];
    }
    else if (flag == 1)
    {
        urlstr = [NSString stringWithFormat:@"%@indexlist?uid=%@&token=%@&city=%@&type=%@&order=%@&limit=10&page=%d&pro=%@&where=%@&subtype=%@&small=%@&big=%@&lat=%@&lng=%@",SERVER_URL,uid,token,cityID,type,order,mpage+1,proID,keyWord,subtype,small,big,lat,longt];
    }
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
        if (mpage == 0) {
             [self.dataArray removeAllObjects];
        }
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
#pragma mark   加载广告页
-(void)getAdData
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@artlist?limit=4&page=1",SERVER_URL];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel1];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        NSLog(@"%@", array);
        self.adArray = [NSMutableArray arrayWithArray:array];
        [self makeTopSC];
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}

#pragma mark  选择城市
-(void)selectCity:(NSString *)city ID:(NSString *)id
{
    cityName = city;
    proID = id;
    if([cityName isEqualToString:@"#全部省份"])
    {
        UIView *view = [self.tabBarController.view viewWithTag:100];
        CityView *cityView = (CityView *)[self.tabBarController.view viewWithTag:2000];
        for (UIView *v in cityView.subviews)
        {
            [v removeFromSuperview];
        }
        [cityView removeFromSuperview];
        
        for (UIView *v in view.subviews)
        {
            [v removeFromSuperview];
        }
        [view removeFromSuperview];
        
        UILabel *label = (UILabel *)[topImageview viewWithTag:40];
        label.text = @"全部省份";
        mpage = 0;
        cityID = @"0";
        keyWord = @"";
        flag = 0;
        [self loadData];
        return;
    }
    
    UIView *view = [self.tabBarController.view viewWithTag:100];
    CityView *cityView = (CityView *)[self.tabBarController.view viewWithTag:2000];
    for (UIView *v in cityView.subviews)
    {
        [v removeFromSuperview];
    }
    [cityView removeFromSuperview];
    
    CityDetailView *cityDetailView = [[CityDetailView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, view.frame.size.height - 90 - 60)];
    cityDetailView.tag = 2001;
    cityDetailView.delegate = self;
    [cityDetailView loadData:proID];
    [self.tabBarController.view addSubview:cityDetailView];
}
-(void)selectCityDetail:(NSString *)city ID:(NSString *)id
{
    cityID = id;
    cityName = city;
    UIView *view = [self.tabBarController.view viewWithTag:100];
    for (UIView *v in view.subviews)
    {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    
    CityDetailView *cityDetailView = (CityDetailView *)[self.tabBarController.view viewWithTag:2001];
    [cityDetailView removeFromSuperview];
    
    UILabel *label = (UILabel *)[topImageview viewWithTag:40];
    label.text = city;
    mpage = 0;
    keyWord = @"";
    flag = 0;
    [self loadData];
}
#pragma mark  选择通告类型
-(void)selectType:(NSString *)type1 ID:(NSString *)id
{
    type = id;
    UIView *view = [self.tabBarController.view viewWithTag:100];
    for (UIView *v in view.subviews)
    {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    
    TypeView *typeView = (TypeView *)[self.tabBarController.view viewWithTag:2002];
    [typeView removeFromSuperview];
    
    UILabel *label = (UILabel *)[topImageview viewWithTag:41];

    
    if([type1 isEqualToString:@"#全部类型"])
    {
        label.text = @"所有类型";
    }
    else
    {
        label.text = type1;
    }
    
    mpage = 0;
    keyWord = @"";
    flag = 0;
    [self loadData];
}
#pragma mark  选择最新发布
-(void)selectRecent:(NSString *)word ID:(NSString *)id
{
    order = id;
    UIView *view = [self.tabBarController.view viewWithTag:100];
    for (UIView *v in view.subviews)
    {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    
    RecentFabuView *recentView = (RecentFabuView *)[self.tabBarController.view viewWithTag:2003];
    [recentView removeFromSuperview];
    
    UILabel *label = (UILabel *)[topImageview viewWithTag:42];
    label.text = word;
    mpage = 0;
    keyWord = @"";
    flag = 0;
    [self loadData];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(CGSize)getSize:(NSString *)str
//{
//    CGSize size;
//    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
//        size = [str boundingRectWithSize:CGSizeMake(166, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
//    }else{
//        size = [str sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(166, 1000)];
//    }
//    return size;
//}
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
