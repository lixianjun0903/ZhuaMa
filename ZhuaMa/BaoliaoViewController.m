//
//  BaoliaoViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "BaoliaoViewController.h"
#import "BaoliaoTableViewCell.h"
#import "BaoLiaoDetailViewController.h"
#import "PressBaoliaoViewController.h"
#import "MJRefresh.h"
#import "ShareView.h"
#import "PicShowView.h"
#import "InputKeyboardView.h"
#import "SearchViewForTrend.h"
#import "PressBaoLiaoNewViewController.h"
@interface BaoliaoViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,commentDelegate,ShareDelegate,PicShowDelegate,inputKeyboardDelegate,SearchTrendDelegate>
{
    NSString *keyWord;
    UITableView *_tableView;
    
    int mpage;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int rowNum;
    
    InputKeyboardView *inputView;
    EmoticonView *eView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property(nonatomic,strong)ImageDownManager *fourDownManager;
@end

@implementation BaoliaoViewController

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
    keyWord = @"";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"爆料" font:20];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:nil selector:@selector(fabuRefreshUI) name:@"pressBLSuccess" object:nil];
}
-(void)fabuRefreshUI
{
    mpage = 0;
    keyWord = @"";
    [self loadData];
}
-(void)announce
{
    PressBaoLiaoNewViewController *vc = [[PressBaoLiaoNewViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
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
    rowNum = 0;
    [self loadData];
}
#pragma mark  创建tableView
-(void)createTableView
{
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
    BaoliaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[BaoliaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
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
    UIView *txView =[eView viewWithText:str andFrame:CGRectMake(55, 40, WIDTH - 25, 1000) FontSize:15];
    CGSize size = CGSizeMake(CGRectGetWidth(txView.frame), CGRectGetHeight(txView.frame));
    txView=nil;
    float height = 10 +size.height + 5;
    NSArray *array =dic[@"image"];
    if (array.count>0) {
        height  =   10+ height + 70 + 10 + 30;
    }
    else
    {
        height =    10+ height + 35;
    }

    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaoLiaoDetailViewController *vc = [[BaoLiaoDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
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
    NSString *urlstr = [NSString stringWithFormat:@"%@commenbid?uid=%@&token=%@&id=%@&text=%@",SERVER_URL,uid,token,dic[@"id"],text];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}
-(void)share:(int)row
{
    rowNum = row;
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+200)];
    shareView.tag = 1000000000;
    shareView.delegate = self;
    shareView.type = @"4";
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
    NSString *str = [keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@baoliaolist?uid=%@&token=%@&where=%@&limit=20&page=%d",SERVER_URL,uid,token,str,mpage+1];
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
#pragma mark  赞爆料
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
    if(_thirdDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSDictionary *dic = self.dataArray[rowNum];
    NSString *urlstr = [NSString stringWithFormat:@"%@approval?uid=%@&token=%@&type=4&tid=%@",SERVER_URL,uid,token,dic[@"id"]];
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
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            NSDictionary *dic = self.dataArray[rowNum];
            int  znum =  [dic[@"anum"] intValue];
            [dic setValue:[NSString stringWithFormat:@"%d",znum +1] forKey:@"anum"];
            [dic setValue:[NSNumber numberWithInt:1] forKey:@"flag"];
            [_tableView reloadData];
            
        }
    }
    
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.thirdDownManager);
}
-(void)deleteZan
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
    
    NSString *urlstr = [NSString stringWithFormat:@"%@canclepraise?uid=%@&token=%@&id=%@&type=2",SERVER_URL,uid,token,dic[@"id"]];
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
            int  znum =  [dic[@"anum"] intValue];
            [dic setValue:[NSString stringWithFormat:@"%d",znum - 1] forKey:@"anum"];
            [dic setValue:[NSNumber numberWithInt:0] forKey:@"flag"];
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
