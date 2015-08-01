//
//  RaiseDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RaiseDetailViewController.h"
#import "FbrDetailTableViewCell.h"
#import "CommentViewController.h"
#import "DetailViewController.h"
#import "RenmaiDetailViewController.h"
#import "LunBoTuViewController.h"
#import "TongGaoDetail2ViewController.h"
#import "RaiseDetailView2ViewController.h"
@interface RaiseDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIImageView *topNav;
    UIView *leftView;
    UILabel *huodongName;
    
    
    
    UIView *rightView;
    UITableView *_tableView;
    
    
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)NSMutableDictionary *userInfoDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property(nonatomic,strong)ImageDownManager *fourDownManager;

@end

@implementation RaiseDetailViewController

-(void)dealloc
{
    _mDownManager.delegate =nil;
    _secDownManager.delegate = nil;
    _thirdDownManager.delegate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self createTopNav];
    //    [self makeUI];
    //    [self makeUIForRight];
    [self createFaburenTop];
    [self loadData];
}

#pragma mark  创建TopNav
-(void)createTopNav
{
    topNav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    topNav.image = [UIImage imageNamed:@"45"];
    topNav.userInteractionEnabled = YES;
    [self.view addSubview:topNav];
    
    UIButton *AnDetailBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH/2, 40) bgImageName:nil imageName:nil title:@"通告详情" selector:@selector(detailBtn:) target:self];
    [AnDetailBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    AnDetailBtn.tag = 10;
    AnDetailBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    AnDetailBtn.selected = YES;
    [topNav addSubview:AnDetailBtn];
    UIButton *FaburenBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, 40) bgImageName:nil imageName:nil title:@"发布人详情" selector:@selector(detailBtn:) target:self];
    [FaburenBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    FaburenBtn.tag = 11;
    FaburenBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [topNav addSubview:FaburenBtn];
    
    UIImageView *bottomLine = [MyControll createImageViewWithFrame:CGRectMake((WIDTH/2 - 120)/2, 37, 120, 3) imageName:@"46"];
    bottomLine.tag = 15;
    [topNav addSubview:bottomLine];
    
}
-(void)detailBtn:(UIButton *)sender
{
    
    int index = (int)sender.tag -10;
    if (index == 1) {
        if (rightView == nil) {
            [self makeUIForRight];
            [self getTableViewData];
            [self getRightData];
        }
    }
    NSLog(@"%d",index);
    UIButton *btn0 = (UIButton *)[topNav viewWithTag:10];
    UIButton *btn1 = (UIButton *)[topNav viewWithTag:11];
    NSArray *tempArray = @[btn0,btn1];
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
        bottomLine.frame = CGRectMake(WIDTH/2 * index + (WIDTH/2 - 120)/2, 37, 120, 3);
    }];
    
    if (index == 0) {
        leftView.hidden = NO;
        rightView.hidden = YES;
    }
    else
    {
        leftView.hidden = YES;
        rightView.hidden = NO;
    }
}
#pragma mark  主UI
-(void)makeUI
{
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 40)];
    leftView.hidden = NO;
    [self.view addSubview:leftView];
    UIScrollView *leftSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, leftView.frame.size.width, leftView.frame.size.height - 60)];
    leftSC.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    leftSC.showsVerticalScrollIndicator = NO;
    
    [leftView addSubview:leftSC];
    
    UIView *firView = [MyControll createViewWithFrame:CGRectMake(0, 10, WIDTH, 75)];
    firView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:firView];
    UILabel *hdlabel = [MyControll createLabelWithFrame:CGRectMake(20, 15, 40, 20) title:@"项目名称" font:16];
    [firView addSubview:hdlabel];
    huodongName = [MyControll createLabelWithFrame:CGRectMake(100, 15, 200, 20) title:self.dataDic[@"name"] font:16];
    [firView addSubview:huodongName];
    
    UILabel *zmTypelabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, 80, 20) title:nil font:15];
    zmTypelabel.text = @"项目类型";
    zmTypelabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [firView addSubview:zmTypelabel];
    
    
    NSArray *colorArray  = @[[UIColor colorWithRed:0.84f green:0.35f blue:0.89f alpha:1.00f]];
    CGSize size = [MyControll getSize:self.dataDic[@"subtype"] Font:13 Width:150 Height:20];
    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(100, 40, size.width + 5, 20)title:self.dataDic[@"subtype"] font:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = colorArray[0];
    [firView addSubview:label];
    
    UIView *secView = [MyControll createViewWithFrame:CGRectMake(0, 95, WIDTH, 90)];
    secView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:secView];
    
    UILabel *placeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH - 40, 20) title:[NSString stringWithFormat:@"所在地区：%@%@%@",self.dataDic[@"pro"],self.dataDic[@"city"],self.dataDic[@"address"]] font:15];
    placeLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [secView addSubview:placeLabel];
    
     NSArray *key = @[@"创意阶段",@"筹备阶段",@"拍摄阶段",@"后期制作阶段",@"发行阶段",@"DEMO阶段",@"测试阶段",@"已上线"];
    UILabel *proNameLabel = [MyControll createLabelWithFrame:CGRectMake(20, 5, WIDTH-40, 20) title:[NSString stringWithFormat:@"项目阶段：%@",key[[self.dataDic[@"paytype"] intValue]-1]] font:15];
    proNameLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [secView addSubview:proNameLabel];
    
    UILabel *partnerLabel = [MyControll createLabelWithFrame:CGRectMake(20, 60, WIDTH - 40, 20) title:[NSString stringWithFormat:@"团队成员：%@",self.dataDic[@"connect"]] font:15];
    partnerLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [secView addSubview:partnerLabel];
    
    
    
    
    UIView *thirdView = [MyControll createViewWithFrame:CGRectMake(0, 195, WIDTH, 90)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:thirdView];
    
    
    UILabel *raiseStateLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, WIDTH-40, 20) title:[NSString stringWithFormat:@"融资阶段：%@",self.dataDic[@"rongtype"]] font:15];
    [thirdView addSubview:raiseStateLabel];
    
    UILabel *raiseGuiMo = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH-40, 20) title:[NSString stringWithFormat:@"融资规模：%@万",self.dataDic[@"lmoney"]] font:15];
    [thirdView addSubview:raiseGuiMo];
    
    UILabel *outPercentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 60, WIDTH-40, 20) title:[NSString stringWithFormat:@"出让股份比例：%@%%",self.dataDic[@"hmoney"]] font:15];
    [thirdView addSubview:outPercentLabel];
    
    
    UIView *fourView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, WIDTH, 130)];
    fourView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:fourView];
    
    UILabel *beizhuLabel = [MyControll createLabelWithFrame:CGRectMake(20, 15, 200, 20) title:@"项目详情" font:16];
    [fourView addSubview:beizhuLabel];
    
    NSArray *picArray = self.dataDic[@"image"];
    if (picArray.count>0) {
        for (int i = 0; i<picArray.count; i++) {
            UIImageView *picImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, beizhuLabel.frame.origin.y+20+20, 60, 60) imageName:nil];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [picImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picShow:)]];
            picImageView.tag = 9000+i;
            [fourView addSubview:picImageView];
        }
        
    }
    else
    {
        
    }
    leftSC.contentSize = CGSizeMake(WIDTH, fourView.frame.origin.y+fourView.frame.size.height+20);
    NSArray *BPArray = self.dataDic[@"bpimage"];
    if (BPArray.count>0) {
        UIView *fifthView = [[UIView alloc]initWithFrame:CGRectMake(0, 445, WIDTH, 120)];
        fifthView.backgroundColor = [UIColor whiteColor];
        [leftSC addSubview:fifthView];
        
        UILabel *BPbeizhuLabel = [MyControll createLabelWithFrame:CGRectMake(20, 15, 200, 20) title:@"商业计划图片" font:16];
        [fifthView addSubview:BPbeizhuLabel];
        for (int i = 0; i<BPArray.count; i++) {
            UIImageView *picImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, beizhuLabel.frame.origin.y+20+20, 60, 60) imageName:nil];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:BPArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [picImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picShow1:)]];
            picImageView.tag = 8000+i;
            [fifthView addSubview:picImageView];
        }
        
        leftSC.contentSize = CGSizeMake(WIDTH, fifthView.frame.origin.y+fifthView.frame.size.height+20);
    }

    
    
    UIImageView *bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, leftView.frame.size.height - 60, WIDTH, 60) imageName:@"51"];
    bottomView.userInteractionEnabled = YES;
    bottomView.alpha = 0.9;
    [leftView addSubview:bottomView];
    
    UIButton *comment = [MyControll createButtonWithFrame:CGRectMake(5, 0, 50, 60) bgImageName:nil imageName:@"48" title:nil selector:@selector(bottomClick:) target:self];
    comment.tag = 20;
    [bottomView addSubview:comment];
    
    UIButton *phone =[MyControll createButtonWithFrame:CGRectMake(WIDTH - 55, 0, 50, 60) bgImageName:nil imageName:@"49" title:nil selector:@selector(bottomClick:) target:self];
    phone.tag = 21;
    [bottomView addSubview:phone];
    
    UIButton *shenqing = [MyControll createButtonWithFrame:CGRectMake((WIDTH - 200)/2, 0, 200, 60) bgImageName:nil imageName:@"50" title:nil selector:@selector(shenqingClick) target:self];
    [bottomView addSubview:shenqing];
    
    if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"0"]) {
        [phone setImage:[UIImage imageNamed:@"unPhone@2x"] forState:UIControlStateNormal];
        phone.enabled = NO;
        [shenqing setImage:[UIImage imageNamed:@"yiguoqi"] forState:UIControlStateNormal];
        shenqing.enabled = NO;
    }
    else
    {
        [phone setImage:[UIImage imageNamed:@"49"] forState:UIControlStateNormal];
        phone.enabled = YES;
        [shenqing setImage:[UIImage imageNamed:@"50"] forState:UIControlStateNormal];
        shenqing.enabled = YES;
    }
    
}
-(void)picShow:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:self.dataDic[@"image"] atIndex:sender.view.tag-9000];
    [self presentViewController:vc animated:NO completion:nil];
    //    [self.navigationController pushViewController:vc animated:NO];
}
-(void)picShow1:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:self.dataDic[@"bpimage"] atIndex:sender.view.tag-8000];
    [self presentViewController:vc animated:NO completion:nil];
    //    [self.navigationController pushViewController:vc animated:NO];
}
-(void)bottomClick:(UIButton *)sender
{
    
    if (sender.tag == 20) {
        CommentViewController *vc = [[CommentViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 21)
    {
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",self.dataDic[@"mobile"]];
        NSURL *telURL =[NSURL URLWithString:telUrl];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
}
#pragma mark  申请通告
-(void)shenqingClick
{
    
    UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"你确定申请“%@”的角色吗？",self.dataDic[@"name"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [a show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self commitShenqing];
    }
}
-(void)commitShenqing
{
    if (_fourDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@createmark?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,_id];
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
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"申请成功"];
        }
        else
        {
            [self showMsg:@"申请失败"];
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
#pragma mark   申请人详情UI
-(void)makeUIForRight
{
    rightView = [MyControll createViewWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 40)];
    rightView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [self.view addSubview:rightView];
    rightView.hidden=YES;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rightView.frame.size.width, rightView.frame.size.height) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator= NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.opaque = NO;
    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [rightView addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FbrDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[FbrDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    if ([dic[@"subtype"]isEqualToString:@"4"]) {
        TongGaoDetail2ViewController *vc = [[TongGaoDetail2ViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([dic[@"subtype"]isEqualToString:@"5"])
    {
        RaiseDetailView2ViewController *vc = [[RaiseDetailView2ViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        DetailViewController *vc = [[DetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.id = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark  发布人详情上部
-(void)createFaburenTop
{
    UIView *fbTopView = [MyControll createViewWithFrame:CGRectMake(0, -150, WIDTH, 100)];
    fbTopView.backgroundColor = [UIColor whiteColor];
    [_tableView addSubview:fbTopView];
    
    UIButton *headView  =[MyControll createButtonWithFrame:CGRectMake(10, 10, 80, 80) bgImageName:nil imageName:@"90" title:nil selector:@selector(headViewClick) target:self];
    [headView sd_setImageWithURL:[NSURL URLWithString:self.userInfoDic[@"face"]] forState:UIControlStateNormal];
    headView.layer.cornerRadius = 5;
    headView.clipsToBounds = YES;
    [fbTopView addSubview:headView];
    
    UILabel *nameLabel  = [MyControll createLabelWithFrame:CGRectMake(100, 10, 200, 20) title:[NSString stringWithFormat:@"姓名：%@",self.userInfoDic[@"name"]] font:16];
    [fbTopView addSubview:nameLabel];
    
    UILabel *dizhiLabel = [MyControll createLabelWithFrame:CGRectMake(100, 35, 200, 15) title:self.userInfoDic[@"city"] font:12];
    [fbTopView addSubview:dizhiLabel];
    
    UILabel *pastLabel = [MyControll createLabelWithFrame:CGRectMake(100, 55, 200, 15) title:[NSString stringWithFormat:@"已经发布过%@次通告",self.userInfoDic[@"num"]] font:12];
    [fbTopView addSubview:pastLabel];
    
    UILabel *phoneNumLabel = [MyControll createLabelWithFrame:CGRectMake(100, 70, 200, 15) title:[NSString stringWithFormat:@"电话：%@",self.userInfoDic[@"mobile"]] font:12];
    [fbTopView addSubview:phoneNumLabel];
    
    UIImageView *midView = [MyControll createImageViewWithFrame:CGRectMake(0, -40, WIDTH, 40) imageName:@"83"];
    [_tableView addSubview:midView];
    
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake((WIDTH - 100)/2, 0, 100, 40) title:@"发布过的通告" font:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [midView addSubview:titleLabel];
}
-(void)headViewClick
{
    RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = self.userInfoDic[@"id"];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@indexinfo3?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_id];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [self makeUI];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark  右侧数据加载
-(void)getRightData
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@userinfo?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,self.dataDic[@"uid"]];
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
        self.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self createFaburenTop];
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}
#pragma mark  发布人详情发布通告tableView
-(void)getTableViewData
{
    if(_thirdDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@announcementedlist?uid=%@&token=%@&tid=%@&limit=10&page=1",SERVER_URL,uid,token,self.dataDic[@"uid"]];
    self.thirdDownManager= [[ImageDownManager alloc]init];
    _thirdDownManager.delegate = self;
    _thirdDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManager.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish2:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel2];
    if (array&&[array isKindOfClass:[NSArray class]]&&array.count>0) {
        self.dataArray  = [NSMutableArray arrayWithArray:array];
        [_tableView reloadData];
        
    }
    
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.thirdDownManager);
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
