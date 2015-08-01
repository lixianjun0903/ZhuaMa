//
//  DetailViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "DetailViewController.h"
#import "LunBoTuViewController.h"
@interface DetailViewController ()
{
    UILabel *huodongName;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation DetailViewController

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
    UILabel *hdlabel = [MyControll createLabelWithFrame:CGRectMake(20, 15, 40, 20) title:@"主题" font:16];
    [firView addSubview:hdlabel];
    huodongName = [MyControll createLabelWithFrame:CGRectMake(100, 15, 200, 20) title:self.dataDic[@"name"] font:16];
    [firView addSubview:huodongName];
    
    UILabel *zmTypelabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, 80, 20) title:nil font:15];
    zmTypelabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [firView addSubview:zmTypelabel];
    
    
    NSArray *colorArray  = @[[UIColor colorWithRed:108.0/256 green:215.0/256 blue:210.0/256 alpha:1]];
    CGSize size = [MyControll getSize:self.dataDic[@"subtype"] Font:13 Width:150 Height:20];
    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(100, 40, size.width + 5, 20)title:self.dataDic[@"subtype"] font:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = colorArray[0];
    [firView addSubview:label];
    
    UIView *secView = [MyControll createViewWithFrame:CGRectMake(0, 95, WIDTH, 90)];
    secView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:secView];
    
    UILabel *placeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, WIDTH - 40, 20) title:nil font:15];
    placeLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [secView addSubview:placeLabel];
    UILabel *moneyLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH-40, 20) title:nil font:15];
    moneyLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [secView addSubview:moneyLabel];
    
    
    UILabel *timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 60, WIDTH - 40, 20) title:[NSString stringWithFormat:@"截止时间：%@",self.dataDic[@"jtime"]] font:15];
    timeLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [secView addSubview:timeLabel];
    
    
    
    
    UIView *thirdView = [MyControll createViewWithFrame:CGRectMake(0, 195, WIDTH, 220)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [leftSC addSubview:thirdView];
    
    UILabel *zmYaoQiuLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, 200, 20) title:nil font:16];
    [thirdView addSubview:zmYaoQiuLabel];
    
    
    if ([self.dataDic[@"type"]isEqualToString:@"1"]) {
        zmTypelabel.text = @"艺人类别";
        placeLabel.text = [NSString stringWithFormat:@"工作地区：%@%@%@",self.dataDic[@"pro"],self.dataDic[@"city"],self.dataDic[@"address"]];
        moneyLabel.text = [NSString stringWithFormat:@"薪资待遇：%@-%@",self.dataDic[@"lmoney"],self.dataDic[@"hmoney"]];
        zmYaoQiuLabel.text = @"招募详情";
    }
    else if ([self.dataDic[@"type"]isEqualToString:@"2"])
    {
        zmTypelabel.text = @"物料类别";
        placeLabel.text = [NSString stringWithFormat:@"所在地区：%@%@%@",self.dataDic[@"pro"],self.dataDic[@"city"],self.dataDic[@"address"]];
        moneyLabel.text =  [NSString stringWithFormat:@"产品报价：%@",self.dataDic[@"lmoney"]];
        zmYaoQiuLabel.text =@"产品详情";
    }
    else if([self.dataDic[@"type"]isEqualToString:@"3"])
    {
        zmTypelabel.text = @"技能类别";
        placeLabel.text = [NSString stringWithFormat:@"所在地区：%@%@%@",self.dataDic[@"pro"],self.dataDic[@"city"],self.dataDic[@"address"]];
        moneyLabel.text = [NSString stringWithFormat:@"价格：%@",self.dataDic[@"lmoney"]];
        zmYaoQiuLabel.text =@"技能详情";
    }
    
    
    
    CGSize sizeOfText = [MyControll getSize:self.dataDic[@"note"] Font:15 Width:WIDTH-40 Height:300];
    
    UILabel *yqDetailLabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, WIDTH - 40, sizeOfText.height+2 +20) title:self.dataDic[@"note"] font:15];
    yqDetailLabel.numberOfLines = 0;
    yqDetailLabel.textColor = [UIColor colorWithRed:0.31f green:0.31f blue:0.31f alpha:1.00f];
    [thirdView addSubview:yqDetailLabel];
    
    
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, 40+20+sizeOfText.height+10, WIDTH - 36, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [thirdView addSubview:line];
    
    UILabel *beizhuLabel = [MyControll createLabelWithFrame:CGRectMake(20, line.frame.origin.y+20, 200, 20) title:@"示例图片" font:16];
    [thirdView addSubview:beizhuLabel];
    
    NSArray *picArray = self.dataDic[@"image"];
    if (picArray.count>0) {
        for (int i = 0; i<picArray.count; i++) {
            UIImageView *picImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, beizhuLabel.frame.origin.y+20+20, 60, 60) imageName:nil];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [picImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picShow:)]];
            picImageView.tag = 9000+i;
            [thirdView addSubview:picImageView];
        }
        
    }
    else
    {
        
    }
    
    thirdView.frame = CGRectMake(0, 195, WIDTH, beizhuLabel.frame.origin.y+20+20+60+10);
    leftSC.contentSize = CGSizeMake(WIDTH, thirdView.frame.origin.y+thirdView.frame.size.height+20);
}
-(void)picShow:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:self.dataDic[@"image"] atIndex:sender.view.tag-9000];
    [self presentViewController:vc animated:NO completion:nil];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@indexinfo1?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_id];
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
