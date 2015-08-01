//
//  RaiseDetailView2ViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/31.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RaiseDetailView2ViewController.h"
#import "LunBoTuViewController.h"
@interface RaiseDetailView2ViewController (){
    UILabel *huodongName;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ImageDownManager *mDownManager;

@end

@implementation RaiseDetailView2ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"通告详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self loadData];
    // Do any additional setup after loading the view.
}
#pragma mark  主UI
-(void)makeUI
{
    UIScrollView *leftSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    leftSC.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    leftSC.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:leftSC];
    
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
}
-(void)picShow:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:self.dataDic[@"image"] atIndex:sender.view.tag-9000];
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)picShow1:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:self.dataDic[@"bpimage"] atIndex:sender.view.tag-8000];
    [self presentViewController:vc animated:NO completion:nil];
    //    [self.navigationController pushViewController:vc animated:NO];
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
