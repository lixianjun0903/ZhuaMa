//
//  TrendViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "TrendViewController.h"
#import "TrendTableViewCell.h"
#import "TrendDetailViewController.h"
#import "PressTrendViewController.h"
#import "MJRefresh.h"
#import "ShareView.h"
#import "PicShowView.h"
#import "InputKeyboardView.h"
#import "TrendTongzhiViewController.h"
#import "SearchViewForTrend.h"
#import "PressDongTaiViewController.h"
@interface TrendViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,commentDelegate,ShareDelegate,PicShowDelegate,inputKeyboardDelegate,SearchTrendDelegate>
{
    UITableView *_tableView;
    int mpage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    int rowNum;
    InputKeyboardView *inputView;
    NSString *tongzhiCount;
    UIButton *tongzhiCountBtn;
    
    NSString *keyword;
    EmoticonView *eView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property(nonatomic,strong)ImageDownManager *fourDownManager;
@property(nonatomic,strong)ImageDownManager*fifthDownManager;

@end

@implementation TrendViewController
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
    mpage = 0;
    rowNum = 0;
    keyword = @"";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"动态" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    [self AddLeftImageBtn:[UIImage imageNamed:@"发布通告.png"] target:self action:@selector(announce)];
    [self AddRightImageBtn:[UIImage imageNamed:@"搜索.png"] target:self action:@selector(search)];
    eView = [[EmoticonView alloc] init];
    [self createTableView];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;

    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
    
    [self loadData];
    [self getDongtaiCount];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:@"pressSuccess" object:nil];
}
-(void)refreshUI
{
    mpage = 0;
    keyword = @"";
    [self loadData];
}
-(void)announce
{
    PressDongTaiViewController *vc = [[PressDongTaiViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)search
{
    SearchViewForTrend *searchView = [[SearchViewForTrend alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64+49)];
    searchView.delegate = self;
    [self.tabBarController.view addSubview:searchView];

}
-(void)search:(SearchViewForTrend *)searchViewForTrend SearchStr:(NSString *)str Flag:(int)flag
{
    keyword = str;
    mpage = 0;
    rowNum = 0;
    [self loadData];
}
#pragma mark  创建tableView
-(void)createTableView
{
    tongzhiCountBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 40) bgImageName:nil imageName:nil title:nil selector:@selector(tongzhiClick) target:self];
    tongzhiCountBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:tongzhiCountBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT + 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.opaque = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[TrendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.row = (int)indexPath.row;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *str = dic[@"text"];
    UIView *txView =[eView viewWithText:str andFrame:CGRectMake(55, 40, WIDTH - 55 - 10, 1000) FontSize:15];
    CGSize size = CGSizeMake(CGRectGetWidth(txView.frame), CGRectGetHeight(txView.frame));
    float height = 40 +size.height;
    NSArray *array =dic[@"image"];
    if (array.count>0) {
        height  = height+5 + 70 + 10 + 30+10 ;
    }
    else
    {
        height = height+5 + 30 +10;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendDetailViewController *vc = [[TrendDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark   显示通知个数
-(void)showTongzhi
{
    if ([tongzhiCount intValue]>0) {
        [tongzhiCountBtn setTitle:tongzhiCount forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.frame = CGRectMake(0, 40, WIDTH, HEIGHT+49-40);
        }];
        
    }
}
-(void)tongzhiClick
{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT+49);
    }];
    TrendTongzhiViewController *vc = [[TrendTongzhiViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark   评论
-(void)comment:(int)row
{
    rowNum = row;
    
    inputView = [[InputKeyboardView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+49+64)];
    inputView.delegate = self;
    [self.view.window addSubview:inputView];
}
-(void)inputKeyboardHide:(InputKeyboardView *)keyboardView
{
    [inputView removeFromSuperview];
}
-(void)inputKeyboardSendText:(NSString *)text
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSDictionary *dic = self.dataArray[rowNum];
    
    //    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@commentopic?uid=%@&token=%@&id=%@&text=%@&tid=%@",SERVER_URL,uid,token,dic[@"id"],text,dic[@"uid"]];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}
#pragma mark  获取数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@topiclist?uid=%@&token=%@&limit=20&page=%d&where=%@",SERVER_URL,uid,token,mpage+1,keyword];
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

-(void)share:(int)row
{
    rowNum = row;
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+200)];
    shareView.tag = 1000000000;
    shareView.delegate = self;
    shareView.type = @"3";
    shareView.tid = self.dataArray[row][@"id"];
    [self.tabBarController.view addSubview:shareView];
}
-(void)shareViewClick:(int)buttonIndex
{
    ShareView *shareView = (ShareView *)[self.tabBarController.view viewWithTag:1000000000];
    if (buttonIndex == 4) {
        [shareView removeFromSuperview];
        shareView = nil;
    }
    else if (buttonIndex == 5)
    {
        NSMutableDictionary *dic = self.dataArray[rowNum];
        NSString *snum = dic[@"snum"];
        int Snums = [snum intValue]+1;
        [self.dataArray[rowNum] setObject:[NSString stringWithFormat:@"%d",Snums] forKey:@"snum"];
        [_tableView reloadData];
    }
    else if (buttonIndex == 0)
    {
        [self showMsg:@"分享失败"];
    }
}
-(void)picShow:(int)row page:(int)page
{
    [self.navigationController setNavigationBarHidden:YES];
    NSArray *picArray = self.dataArray[row][@"image"];
    PicShowView *picShowView = [[PicShowView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+49)];
    picShowView.tag = 20000;
    picShowView.delegate = self;
    [picShowView loadPicFromArray:picArray page:page];
    [self.view.window addSubview:picShowView];
}
-(void)removeShowView
{
    [self.navigationController setNavigationBarHidden:NO];
    PicShowView *picShowView = (PicShowView *)[self.view.window viewWithTag:20000];
    for (UIView *view in picShowView.subviews) {
        [view removeFromSuperview];
    }
    [picShowView removeFromSuperview];
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
        keyword = @"";
        [self loadData];
        [self getDongtaiCount];
        
    }
    else
    {
        [self loadData];
    }
    
}
#pragma mark  评论
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"评论成功"];
            NSDictionary *dic = self.dataArray[rowNum];
            int  cnum =  [dic[@"cnum"] intValue];
            [dic setValue:[NSString stringWithFormat:@"%d",cnum +1] forKey:@"cnum"];
            [_tableView reloadData];
        }
        else
        {
            [self showMsg:@"评论失败"];
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
#pragma mark  获取动态通知个数  
-(void)getDongtaiCount
{
    if(_thirdDownManager)
    {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@topicnotenum?uid=%@&token=%@",SERVER_URL,uid,token];
    self.thirdDownManager= [[ImageDownManager alloc]init];
    _thirdDownManager.delegate = self;
    _thirdDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManager.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish2:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel2];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        tongzhiCount = [NSString stringWithFormat:@"%@",dict[@"num"]];
    }
    else
    {
        tongzhiCount = @"0";
    }
    [self showTongzhi];
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    SAFE_CANCEL_ARC(self.thirdDownManager);
}
#pragma mark   赞动态
-(void)zan:(int)row
{
    rowNum = row;
    NSDictionary *dic = self.dataArray[row];
    if ([[dic[@"flag"]stringValue]isEqualToString:@"0"]) {
        [self addZan];
    }
    else if ([[dic[@"flag"]stringValue]isEqualToString:@"1"])
    {
        [self deleteZan];
    }
}
-(void)addZan
{
    if(_fourDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSDictionary *dic = self.dataArray[rowNum];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@approval?uid=%@&token=%@&type=3&tid=%@",SERVER_URL,uid,token,dic[@"id"]];
    self.fourDownManager= [[ImageDownManager alloc]init];
    _fourDownManager.delegate = self;
    _fourDownManager.OnImageDown = @selector(OnLoadFinish3:);
    _fourDownManager.OnImageFail = @selector(OnLoadFail3:);
    [_fourDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish3:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel3];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            NSDictionary *dic = self.dataArray[rowNum];
            int  znum =  [dic[@"znum"] intValue];
            [dic setValue:[NSString stringWithFormat:@"%d",znum +1] forKey:@"znum"];
            [dic setValue:[NSNumber numberWithInt:1] forKey:@"flag"];
            [_tableView reloadData];

        }
    }
    
}
- (void)OnLoadFail3:(ImageDownManager *)sender {
    [self Cancel3];
}
- (void)Cancel3 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.fourDownManager);
}
-(void)deleteZan
{
    if(_fifthDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSDictionary *dic = self.dataArray[rowNum];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@canclepraise?uid=%@&token=%@&id=%@&type=1",SERVER_URL,uid,token,dic[@"id"]];
    self.fifthDownManager= [[ImageDownManager alloc]init];
    _fifthDownManager.delegate = self;
    _fifthDownManager.OnImageDown = @selector(OnLoadFinish4:);
    _fifthDownManager.OnImageFail = @selector(OnLoadFail4:);
    [_fifthDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish4:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel4];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            NSDictionary *dic = self.dataArray[rowNum];
            int  znum =  [dic[@"znum"] intValue];
            [dic setValue:[NSString stringWithFormat:@"%d",znum -1] forKey:@"znum"];
            [dic setValue:[NSNumber numberWithInt:0] forKey:@"flag"];
            [_tableView reloadData];
            
        }
    }
    
}
- (void)OnLoadFail4:(ImageDownManager *)sender {
    [self Cancel4];
}
- (void)Cancel4 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.fifthDownManager);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _header.scrollView = nil;
    _footer.scrollView = nil;

}
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
