//
//  JubaoViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "JubaoViewController.h"

@interface JubaoViewController ()
{
    UIView *bgView;
    NSString *choseText;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation JubaoViewController

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
    choseText = @"";
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"举报" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *send = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"发送" selector:@selector(send) target:self];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    jubao.titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:send];
    [self makeUI];
}
-(void)send
{
    if ([choseText isEqualToString:@""]) {
        [self showMsg:@"你还没有选择投诉原因"];
        return;
    }
    [self loadData];
}
#pragma mark   创建主UI
-(void)makeUI
{
    UILabel *tishiLabel = [MyControll createLabelWithFrame:CGRectMake(20, 20, 200, 20) title:@"请选择投诉原因" font:15];
    [self.view addSubview:tishiLabel];
    
    
    bgView = [MyControll createToolView2WithFrame:CGRectMake(0, 60, WIDTH, 250) withColor:[UIColor whiteColor] withNameArray:@[@"色情",@"欺诈骗钱",@"侮辱诋毁",@"广告骚扰",@"政治"]];
    [self.view addSubview:bgView];
    
    for (int i= 0; i<5; i++) {
        UIButton *jubaoBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-60, i*50, 40, 50) bgImageName:nil imageName:@"57" title:nil selector:@selector(jubaoBtn:) target:self];
        [jubaoBtn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
        jubaoBtn.tag = 10+i;
        [bgView addSubview:jubaoBtn];
    }
    
    
}
-(void)jubaoBtn:(UIButton *)sender
{
    int index = (int)sender.tag -10;
    NSArray *textArray =  @[@"色情",@"欺诈骗钱",@"侮辱诋毁",@"广告骚扰",@"政治"];
    choseText = textArray[index];
    for (int i = 0; i<5; i++) {
        UIButton *btn = (UIButton *)[bgView viewWithTag:10+i];
        if (btn.tag  == index+10) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
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
    NSString *urlstr = [NSString stringWithFormat:@"%@reporterror?uid=%@&token=%@&type=%d&targetid=%@&text=%@",SERVER_URL,uid,token,_type,_id,choseText];
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
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"提交成功,等待验证"];
            [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:@"提交失败"];
        }
    }
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
