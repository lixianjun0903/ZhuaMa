//
//  ShenqingrenDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "ShenqingrenDetailViewController.h"
#import "PhotoCheckViewController.h"
@interface ShenqingrenDetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView *mainSC;
    UIView *firstView;
    
    
    UIButton *headView;
    UILabel *nameLabel;
    UILabel *sexLabel;
    UILabel *birthdayLabel;
    UILabel *birthplaceLabel;
    UILabel *homeLabel;
    UILabel *qianmingLabel;
    UILabel *hangyeLabel;
    UILabel *zuopinLabel;
    UILabel *zhiweiLabel;
    UILabel *heightLabel;
    UILabel *weightLabel;
    UILabel *bloodLabel;
    UILabel *xingzuoLabel;
    UILabel *biaoqianLabel;
    UILabel *jingliLabel;
    UILabel *eduJingliLabel;
    
    UILabel *phoneLabel;
    UILabel *emialLabel;
    UILabel *weichatLabel;
    
    UILabel *hobbyLabel;
    UILabel *schoolLabel;

}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableDictionary *infoDic;
@end

@implementation ShenqingrenDetailViewController

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
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 100, 35) title:@"申请人详情" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate = self;
    mainSC.contentSize = CGSizeMake(WIDTH, 1020+64 + 70);
    [self.view addSubview:mainSC];
    
    firstView = [MyControll createToolView3WithFrame:CGRectMake(0, 10, WIDTH, 18*40) withColor:[UIColor whiteColor] withNameArray:@[@"头像",@"个人相册",@"真实姓名",@"性别",@"出生日期",@"所在地",@"家乡",@"个人签名",@"行业",@"作品",@"职位",@"身高",@"体重",@"血型",@"星座",@"个人标签",@"工作经历",@"教育经历"]];
    [mainSC addSubview:firstView];
    
    headView = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 60, 15, 50, 50) bgImageName:nil imageName:nil title:nil selector:nil target:self];
    headView.clipsToBounds = YES;
//    headView.enabled = NO;
    headView.layer.cornerRadius = 5;
    [firstView addSubview:headView];
    
    UILabel *xiangceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 80, 170, 40) title:nil font:15];
    xiangceLabel.textAlignment = NSTextAlignmentRight;
    xiangceLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:xiangceLabel];
    
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 120, 170, 40) title:nil font:15];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:nameLabel];
    sexLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 160, 170, 40) title:nil font:15];
    sexLabel.textAlignment = NSTextAlignmentRight;
    sexLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:sexLabel];
    birthdayLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 200, 170, 40) title:nil font:15];
    birthdayLabel.textAlignment = NSTextAlignmentRight;
    birthdayLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:birthdayLabel];
    birthplaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 240, 170, 40) title:nil font:15];
    birthplaceLabel.textAlignment = NSTextAlignmentRight;
    birthplaceLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:birthplaceLabel];
    homeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 280, 170, 40) title:nil font:15];
    homeLabel.textAlignment = NSTextAlignmentRight;
    homeLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:homeLabel];
    qianmingLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 320, 170, 40) title:nil font:15];
    qianmingLabel.textAlignment = NSTextAlignmentRight;
    qianmingLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:qianmingLabel];
    hangyeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 360, 170, 40) title:nil font:15];
    hangyeLabel.textAlignment = NSTextAlignmentRight;
    hangyeLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:hangyeLabel];
    zuopinLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 400, 170, 40) title:nil font:15];
    zuopinLabel.textAlignment = NSTextAlignmentRight;
    zuopinLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:zuopinLabel];
    zhiweiLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 440, 170, 40) title:nil font:15];
    zhiweiLabel.textAlignment = NSTextAlignmentRight;
    zhiweiLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:zhiweiLabel];
    heightLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 480, 170, 40) title:nil font:15];
    heightLabel.textAlignment = NSTextAlignmentRight;
    heightLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:heightLabel];
    
    weightLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 520, 170, 40) title:nil font:15];
    weightLabel.textAlignment = NSTextAlignmentRight;
    weightLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:weightLabel];
    bloodLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 560, 170, 40) title:nil font:15];
    bloodLabel.textAlignment = NSTextAlignmentRight;
    bloodLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:bloodLabel];
    xingzuoLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 600, 170, 40) title:nil font:15];
    xingzuoLabel.textAlignment = NSTextAlignmentRight;
    xingzuoLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:xingzuoLabel];
    biaoqianLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 640, 170, 40) title:nil font:15];
    biaoqianLabel.textAlignment = NSTextAlignmentRight;
    biaoqianLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:biaoqianLabel];
    jingliLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 680, 170, 40) title:@">" font:15];
    jingliLabel.textAlignment = NSTextAlignmentRight;
    jingliLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:jingliLabel];
    
    eduJingliLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-180, 720, 170, 40) title:@">" font:15];
    eduJingliLabel.textAlignment = NSTextAlignmentRight;
    eduJingliLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:eduJingliLabel];
    
    
    UILabel *contactWay = [MyControll createLabelWithFrame:CGRectMake(20, 780, 240, 30) title:@"联系方式" font:15];
    [mainSC addSubview:contactWay];
    
    UIView *secView = [MyControll createToolView2WithFrame:CGRectMake(0, 820, WIDTH, 120) withColor:[UIColor whiteColor] withNameArray:@[@"手机",@"邮箱",@"微信"]];
    [mainSC addSubview:secView];
    
    phoneLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 0, 170, 40) title:nil font:15];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.textColor = [UIColor lightGrayColor];
    [secView addSubview:phoneLabel];
    
    emialLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 40, 170, 40) title:nil font:15];
    emialLabel.textColor = [UIColor lightGrayColor];
    emialLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:emialLabel];
    
    weichatLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 80, 170, 40) title:nil font:15];
    weichatLabel.textColor = [UIColor lightGrayColor];
    weichatLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:weichatLabel];
    
    
    
    UIView *thirdView = [MyControll createToolView2WithFrame:CGRectMake(0, 960, WIDTH, 80) withColor:[UIColor whiteColor] withNameArray:@[@"特长技能",@"学校"]];
    [mainSC addSubview:thirdView];
    
    hobbyLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 0, 170, 40) title:nil font:15];
    hobbyLabel.textColor = [UIColor lightGrayColor];
    hobbyLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:hobbyLabel];
    
    schoolLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 40, 170, 40) title:nil font:15];
    schoolLabel.textColor = [UIColor lightGrayColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:schoolLabel];
    
    UIButton *GotoXiangce = [MyControll createButtonWithFrame:CGRectMake(0, 80, WIDTH, 40) bgImageName:nil imageName:nil title:nil selector:@selector(GotoNextClick:) target:self];
    GotoXiangce.tag = 500;
    [firstView addSubview:GotoXiangce];
    
    for (int i = 0; i<2; i++) {
        UIButton *GotoWorkAndEdu = [MyControll createButtonWithFrame:CGRectMake(0, 680+40*i, WIDTH, 40) bgImageName:nil imageName:nil title:nil selector:@selector(GotoNextClick:) target:self];
        GotoWorkAndEdu.tag = 501+i;
        [firstView addSubview:GotoWorkAndEdu];
    }
    

}
-(void)GotoNextClick:(UIButton *)sender
{
    int index = (int)sender.tag-500;
    if (index == 0) {
        PhotoCheckViewController *vc =[[PhotoCheckViewController alloc]init];
        vc.picArray = self.infoDic[@"image"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        
    }
    else if (index ==2)
    {
        
    }
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
    NSString *urlstr = [NSString stringWithFormat:@"%@userinfo2?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,_id];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary  *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count>0) {
        self.infoDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self refreshUI];
    }
    else if(dict.count == 0)
    {
        
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)refreshUI
{
    if ([self.infoDic[@"face"] isEqualToString:@""]) {
        [headView setImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
        }
    else
    {
        [headView sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"face"]] forState:UIControlStateNormal];
    }
    if ([self.infoDic[@"name"] isEqualToString:@""]) {
        nameLabel.text= @"无";
    }
    else
    {
        nameLabel.text = self.infoDic[@"name"];
    }
    if ([self.infoDic[@"sex"] isEqualToString:@"0"]) {
        sexLabel.text = @"男";
    }
    else
    {
        sexLabel.text = @"女";
    }
    if ([self.infoDic[@"birthday"] isEqualToString:@""]) {
        birthdayLabel.text = @"无";
        
    }
    else
    {
        birthdayLabel.text = self.infoDic[@"birthday"];
    }
    if ([self.infoDic[@"city"] isEqualToString:@""]) {
        birthplaceLabel.text = @">";
    }
    else
    {
        birthplaceLabel.text = self.infoDic[@"city"];
    }
    if ([self.infoDic[@"sign"] isEqualToString:@""]) {
        qianmingLabel.text = @">";
    }
    else{
        qianmingLabel.text = self.infoDic[@"sign"];
    }
    if ([self.infoDic[@"home"] isEqualToString:@""]) {
        homeLabel.text = @">";
    }
    else{
        homeLabel.text = self.infoDic[@"home"];
    }
    hangyeLabel.text = self.infoDic[@"type"];
    if ([self.infoDic[@"pin"] isEqualToString:@""]) {
        zuopinLabel.text = @">";
    }
    else
    {
        zuopinLabel.text = self.infoDic[@"pin"];
    }
    if ([self.infoDic[@"post"] isEqualToString:@""]) {
        zhiweiLabel.text = @">";
    }
    else{
        zhiweiLabel.text = self.infoDic[@"post"];
    }
    if ([self.infoDic[@"height"] isEqualToString:@""]) {
        heightLabel.text = @">";
    }
    else{
        heightLabel.text = [NSString stringWithFormat:@"%@cm",self.infoDic[@"height"]];
    }
    if ([self.infoDic[@"weight"] isEqualToString:@""]) {
        weichatLabel.text = @">";
    }
    else{
        weightLabel.text = [NSString stringWithFormat:@"%@kg",self.infoDic[@"weight"]];
    }
    if ([self.infoDic[@"xuex"] isEqualToString:@""]) {
        bloodLabel.text = @">";
    }
    else
    {
        bloodLabel.text = self.infoDic[@"xuex"];
    }
    if ([self.infoDic[@"constellation"] isEqualToString:@""]) {
        xingzuoLabel.text = self.infoDic[@"constellation"];
    }
    else
    {
        xingzuoLabel.text = self.infoDic[@"constellation"];
    }
    if ([(NSArray *)self.infoDic[@"tags"] count]==0) {
        biaoqianLabel.text = @">";
    }
    else{
        NSMutableString *str =[NSMutableString stringWithCapacity:0];
        for (NSDictionary *dic in self.infoDic[@"tags"]) {
            if (str.length == 0) {
                [str appendString:[NSString stringWithFormat:@"%@",dic[@"tag"]]];
            }
            else
            {
                [str appendString:[NSString stringWithFormat:@"/%@",dic[@"tag"]]];
            }
        }
        biaoqianLabel.text = str;
    }
    if ([self.infoDic[@"mobile"] isEqualToString:@""]) {
        phoneLabel.text = @">";
    }
    else{
        phoneLabel.text = self.infoDic[@"mobile"];
    }
    if ([self.infoDic[@"email"] isEqualToString:@""]) {
        emialLabel.text =@">";
    }
    else{
        emialLabel.text =self.infoDic[@"email"];
    }
    if ([self.infoDic[@"wei"] isEqualToString:@""]) {
        weichatLabel.text =@">";
    }
    else{
        weichatLabel.text =self.infoDic[@"wei"];
    }
    if ([(NSArray *)self.infoDic[@"honny"] count]==0) {
        hobbyLabel.text = @">";
    }
    else{
        NSMutableString *str=[NSMutableString stringWithCapacity:0];
        for (NSDictionary *dic in self.infoDic[@"honny"]) {
            if (str.length == 0) {
                [str appendString:[NSString stringWithFormat:@"%@",dic[@"name"]]];
            }
            else
            {
                [str appendString:[NSString stringWithFormat:@"、%@",dic[@"tag"]]];
            }
        }
        hobbyLabel.text = str;
    }
    if ([self.infoDic[@"school"] isEqualToString:@""]) {
        schoolLabel.text = @">";
    }
    else
    {
        schoolLabel.text = self.infoDic[@"school"];
    }
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
