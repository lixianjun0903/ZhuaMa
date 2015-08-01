//
//  ShenqingListViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "ShenqingListViewController.h"
#import "ShenqingListTableViewCell.h"
#import "ShenqingrenDetailViewController.h"
@interface ShenqingListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIImageView *topNav;
    UIImageView *bottomView;
    
    int type;

    int flag;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation ShenqingListViewController

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
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"申请名单" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self createTopNav];
    [self createTableView];
    [self createBottomView];
    [self loadData];
    // Do any additional setup after loading the view.
}
#pragma mark  上面导航topNav
-(void)createTopNav
{
    topNav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    topNav.image = [UIImage imageNamed:@"7"];
    topNav.userInteractionEnabled = YES;
    [self.view addSubview:topNav];
    
    UIButton *yishenqingBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH/3, 40) bgImageName:nil imageName:nil title:@"未处理" selector:@selector(detailBtn:) target:self];
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
    NSLog(@"%d",index);
    if (type == index) {
        return;
    }
    else
    {
        type =index;
        [self.dataArray removeAllObjects];
        [self loadData];
    }
    
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
    
    if (type==0) {
        bottomView.hidden = NO;
    }
    else
    {
        bottomView.hidden = YES;
    }
}
-(void)createBottomView
{
    bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - 60 -64, WIDTH, 60) imageName:@"51"];
    bottomView.userInteractionEnabled = YES;
    bottomView.alpha = 0.9;
    bottomView.hidden = NO;
    [self.view addSubview:bottomView];
    
    UIButton *agreeBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-120)/2, 0, 120, 60) bgImageName:nil imageName:@"tongguo" title:nil selector:@selector(bottomClick:) target:self];
    agreeBtn.tag = 2000;
    [bottomView addSubview:agreeBtn];

    
    UIButton *disagreeBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2 - 120)/2+WIDTH/2, 0, 120, 60) bgImageName:nil imageName:@"jujue" title:nil selector:@selector(bottomClick:) target:self];
    disagreeBtn.tag = 2001;
    [bottomView addSubview:disagreeBtn];
}
-(void)bottomClick:(UIButton *)sender
{
    if (sender.tag == 2000) {
        if (self.selectArray.count == 0) {
            [self showMsg:@"你还没选择通告"];
        }
        else
        {
            flag = 1;
            [self commitLoad];
        }
    }
    else if (sender.tag == 2001)
    {
        if (self.selectArray.count == 0) {
            [self showMsg:@"你还没选择通告"];
        }
        else
        {
            flag = 2;
            [self commitLoad];
        }
    }
}
#pragma mark  创建tableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT -40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.opaque = NO;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 60, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor= [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShenqingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ShenqingListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    for (UIView *view in cell.accessoryView.subviews) {
        [view removeFromSuperview];
    }
    cell.accessoryView = nil;
    if (type == 0) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, (85-50)/2, 60, 50)];
        [btn setImage:[UIImage imageNamed:@"57"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
    }
    else
    {
        cell.accessoryView = nil;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShenqingrenDetailViewController *vc = [[ShenqingrenDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"uid"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)btn:(UIButton *)sender
{
    BOOL isSel = sender.selected;
    if (isSel) {
        sender.selected = NO;
        int row = (int)sender.tag;
        NSDictionary *dic = self.dataArray[row];
        [self.selectArray removeObject:dic[@"id"]];
    }
    else
    {
        sender.selected = YES;
        int row = (int)sender.tag;
        NSDictionary *dic = self.dataArray[row];
        [self.selectArray addObject:dic[@"id"]];
    }
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
    NSString *urlstr = [NSString stringWithFormat:@"%@marklist?uid=%@&token=%@&id=%@&flag=%d",SERVER_URL,uid,token,_id,type];
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
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark
-(void)commitLoad
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *selectIds = [self.selectArray JSONRepresentation];
    NSString *urlstr = [NSString stringWithFormat:@"%@handlemark?uid=%@&token=%@&ids=%@&flag=%d",SERVER_URL,uid,token,selectIds,flag];
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
            [self showMsg:@"处理成功"];
            for (NSString *ids in self.selectArray) {
                for (NSDictionary *dic in self.dataArray) {
                    if ([dic[@"id"] isEqualToString:ids]) {
                        [self.dataArray removeObject:dic];
                    }
                }
            }
            [_tableView reloadData];
            [self.selectArray removeAllObjects];
        }
        else
        {
            [self showMsg:@"处理失败"];
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
