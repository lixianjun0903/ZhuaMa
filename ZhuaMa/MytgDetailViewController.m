//
//  MytgDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MytgDetailViewController.h"
#import "ShenqingListViewController.h"
@interface MytgDetailViewController ()

@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation MytgDetailViewController

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
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"通告详情" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *shareBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"47" title:nil selector:@selector(onShareClick) target:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
//    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)onShareClick
{
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 60;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.tabBarController.view addSubview:view];
    
    UIView *shareView = [MyControll createViewWithFrame:CGRectMake(0, HEIGHT + 64, WIDTH, 220)];
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, HEIGHT + 64 -220, WIDTH, 220);
    }];
    shareView.tag = 70;
    shareView.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.view addSubview:shareView];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake((WIDTH-200)/2, 20, 200, 20) title:@"分享到" font:18];
    tishi.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:tishi];
    
    NSArray *sharePic = @[@"60",@"61",@"62",@"63"];
    NSArray *shareTitle = @[@"微信好友",@"QQ好友",@"朋友圈",@"新浪微博"];
    for (int i = 0; i<sharePic.count; i++) {
        UIButton *sharebtn = [MyControll createButtonWithFrame:CGRectMake(10+WIDTH/4 *i, 50, WIDTH/4 - 20, WIDTH/4 - 20) bgImageName:nil imageName:sharePic[i] title:nil selector:@selector(shareBtnClick:) target:self];
        sharebtn.tag = 100000+i;
        [shareView addSubview:sharebtn];
        
        UILabel *shareLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/4 *i, 50 + WIDTH/4, WIDTH/4, 20) title:shareTitle[i] font:14];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:shareLabel];
    }
    
    
    UIButton *cancelBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-300)/2, 50 + WIDTH/4+40, 300, 40) bgImageName:nil imageName:@"64" title:nil selector:@selector(shareBtnClick:) target:self];
    cancelBtn.tag = 100004;
    [shareView addSubview:cancelBtn];
}
-(void)shareBtnClick:(UIButton *)sender
{
    
}
-(void)tap:(UIGestureRecognizer *)sendre
{
    
    UIView *view1 = [self.tabBarController.view viewWithTag:70];
    [UIView animateWithDuration:0.2 animations:^{
        view1.frame =CGRectMake(0, HEIGHT + 64, WIDTH, 220);
    } completion:^(BOOL finished) {
        UIView *view1 = [self.tabBarController.view viewWithTag:70];
        for (UIView *v in view1.subviews) {
            [v removeFromSuperview];
        }
        [view1 removeFromSuperview ];
        view1 = nil;
        
        UIView *view = [self.tabBarController.view viewWithTag:60];
        for (UIView *v in view.subviews) {
            [v removeFromSuperview];
        }
        [view removeFromSuperview ];
        view = nil;
        
    }];
    
    
}
#pragma mark  UI
-(void)makeUI
{
    UIScrollView *leftSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60)];
    leftSC.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    leftSC.showsVerticalScrollIndicator = NO;
    leftSC.contentSize = CGSizeMake(WIDTH, 415 + 64);
    [self.view addSubview:leftSC];
    
    UIView *firView = [MyControll createViewWithFrame:CGRectMake(0, 10, WIDTH, 75)];
    firView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:firView];
    UILabel *hdlabel = [MyControll createLabelWithFrame:CGRectMake(20, 15, 40, 20) title:@"活动" font:16];
    [firView addSubview:hdlabel];
    UILabel* huodongName = [MyControll createLabelWithFrame:CGRectMake(100, 15, 200, 20) title:self.dataDic[@"name"] font:16];
    [firView addSubview:huodongName];
    
    UILabel *zmTypelabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, 80, 20) title:@"招募类型" font:15];
    zmTypelabel.textColor = [UIColor lightGrayColor];
    [firView addSubview:zmTypelabel];
    
    NSArray *tempArray = @[@"专业演员",@"群众"];
    NSArray *colorArray  = @[[UIColor colorWithRed:108.0/256 green:215.0/256 blue:210.0/256 alpha:1],[UIColor colorWithRed:255.0/256 green:208.0/256 blue:111.0/256 alpha:1]];
    float width = 0;
    for (int i = 0; i < tempArray.count; i++) {
        CGSize size = [tempArray[i] sizeWithFont:[UIFont systemFontOfSize:13] forWidth:60 lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(100 + width, 40, size.width + 5, 20) title:tempArray[i] font:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = colorArray[i];
        [firView addSubview:label];
        width += size.width + 10;
    }
    
    UIView *secView = [MyControll createViewWithFrame:CGRectMake(0, 95, WIDTH, 90)];
    secView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:secView];
    
    UILabel *placeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, 100, 20) title:[NSString stringWithFormat:@"%@|",self.dataDic[@"pro"]] font:15];
    placeLabel.textColor = [UIColor lightGrayColor];
    [secView addSubview:placeLabel];
    UILabel *moneyLabel = [MyControll createLabelWithFrame:CGRectMake(120, 10, 120, 20) title:[NSString stringWithFormat:@"%@-%@",self.dataDic[@"lmoney"],self.dataDic[@"hmoney"]] font:15];
    moneyLabel.textColor = [UIColor redColor];
    [secView addSubview:moneyLabel];
    UILabel *  detailPlaceLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH - 40, 20) title:[NSString stringWithFormat:@"详细地址：%@",self.dataDic[@"jaddress"]] font:15];
    detailPlaceLabel.textColor = [UIColor lightGrayColor];
    [secView addSubview:detailPlaceLabel];
    
    UILabel *timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 60, WIDTH - 40, 20) title:[NSString stringWithFormat:@"集合时间：%@",self.dataDic[@"jtime"]] font:15];
    timeLabel.textColor = [UIColor lightGrayColor];
    [secView addSubview:timeLabel];
    
    UIView *thirdView = [MyControll createViewWithFrame:CGRectMake(0, 195, WIDTH, 220)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:thirdView];
    
    UILabel *zmYaoQiuLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, 200, 20) title:@"招募要求" font:16];
    [thirdView addSubview:zmYaoQiuLabel];
    
    
    NSMutableString *detailStr = [NSMutableString stringWithFormat:@"%@人",self.dataDic[@"snum"]];
    if ([self.dataDic[@"sex"] isEqualToString:@"1"]) {
        [detailStr appendString:@"|男性"];
    }
    else if([self.dataDic[@"sex"] isEqualToString:@"2"])
    {
        [detailStr appendString:@"|女性"];
    }
    else{
        [detailStr appendString:@"|性别不限"];
    }
    if (![self.dataDic[@"height"]isEqualToString:@"0"]) {
        [detailStr appendString:[NSString stringWithFormat:@"|身高%@厘米左右",self.dataDic[@"height"]]];
    }
    if (![self.dataDic[@"weight"]isEqualToString:@"0"]) {
        [detailStr appendString:[NSString stringWithFormat:@"|体重%@公斤左右",self.dataDic[@"weight"]]];
    }
    
    CGSize size =  [self getSize:detailStr];
    
    
    UILabel *yqDetailLabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, WIDTH - 40, size.height+2 +20) title:detailStr font:15];
    yqDetailLabel.textColor = [UIColor lightGrayColor];
    [thirdView addSubview:yqDetailLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, 40+20+size.height+10, WIDTH - 36, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [thirdView addSubview:line];
    
    UILabel *beizhuLabel = [MyControll createLabelWithFrame:CGRectMake(20, line.frame.origin.y+20, 200, 20) title:@"备注" font:16];
    [thirdView addSubview:beizhuLabel];
    NSString *str = self.dataDic[@"text"];
    CGSize sizeofstr = [str boundingRectWithSize:CGSizeMake(WIDTH - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    UILabel *desc = [MyControll createLabelWithFrame:CGRectMake(20, beizhuLabel.frame.origin.y+beizhuLabel.frame.size.height+10, WIDTH - 40, sizeofstr.height + 10) title:str font:15];
    desc.textColor = [UIColor lightGrayColor];
    [thirdView addSubview:desc];
    
    thirdView.frame = CGRectMake(0, 195, WIDTH, desc.frame.origin.y+desc.frame.size.height+10);
    leftSC.contentSize = CGSizeMake(WIDTH, thirdView.frame.origin.y+thirdView.frame.size.height+20);
    
    UIImageView *bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - 60, WIDTH, 60) imageName:@"51"];
    bottomView.userInteractionEnabled = YES;
    bottomView.alpha = 0.9;
    [self.view addSubview:bottomView];
    
    UIButton *shenqing = [MyControll createButtonWithFrame:CGRectMake((WIDTH - 200)/2, 0, 200, 60) bgImageName:nil imageName:@"chakanshenqingmingdan" title:nil selector:@selector(shenqingClick) target:self];
    [bottomView addSubview:shenqing];
}
-(void)shenqingClick
{
    ShenqingListViewController *vc = [[ShenqingListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataDic[@"id"];
    [self.navigationController pushViewController: vc animated:YES];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@indexinfo?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_id];    self.mDownManager= [[ImageDownManager alloc]init];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)getSize:(NSString *)str
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(WIDTH - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(WIDTH - 40, 1000)];
    }
    return size;
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
