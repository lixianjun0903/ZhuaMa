//
//  ForgetPWDViewController.m
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "GetCheckMaView.h"
#import "RegexKitLite.h"
#import "SetPWDViewController.h"
@interface ForgetPWDViewController ()<GetCheckDelegate>
{
    UITextField *phoneNum;
    UITextField *checkMa;
    GetCheckMaView *getCheckView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@end

@implementation ForgetPWDViewController
-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.94f alpha:1.00f];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"忘记密码" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    [self makeUI];
}
-(void)makeUI
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [self.view addSubview:bgView];
    
    phoneNum = [MyControll createTextFieldWithFrame:CGRectMake(20, 5, WIDTH-130, 40) text:nil placehold:@"请输入注册手机号" font:15];
    [bgView addSubview:phoneNum];
    UIView *line = [MyControll createViewWithFrame:CGRectMake(0, 50, WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [bgView addSubview:line];
    
    getCheckView = [[GetCheckMaView alloc] initWithFrame:CGRectMake(WIDTH-100, 0, 90, 50)];
    getCheckView.delegate = self;
    [bgView addSubview:getCheckView];
    
    
    checkMa = [MyControll createTextFieldWithFrame:CGRectMake(20, 50, WIDTH-30, 50) text:nil placehold:@"输入短信验证码" font:15];
    [bgView addSubview:checkMa];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 160, 260, 50) bgImageName:nil imageName:@"wanc@2x" title:nil selector:@selector(checkMa) target:self];
    [self.view addSubview:commit];
    
}
-(void)checkWrong
{
    [self showMsg:@"手机号码格式错误"];
}
#pragma mark  获取验证码
-(void)getCheckMa
{
    if(_mDownManager)
    {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@sendcode?mobile=%@&type=%d",SERVER_URL,phoneNum.text,1];
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
    if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
        NSLog(@"验证码发送成功");
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark  检查验证码是否正确
-(void)buttonClick
{
    if (![self checkPassWD:phoneNum.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    else
    {
        [getCheckView startCheck];
    }
}
-(void)checkMa
{
    [self.view endEditing:YES];
    if (![self checkPassWD:phoneNum.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    else if (checkMa.text.length<4)
    {
        [self showMsg:@"验证码格式不正确"];
        return;
    }
    if(_secDownManager)
    {
        return;
    }
        [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@rightcode?mobile=%@&code=%@",SERVER_URL,phoneNum.text,checkMa.text];
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
    if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
        NSLog(@"验证码匹配成功");
        SetPWDViewController *vc = [[SetPWDViewController alloc]init];
        vc.phoneNum = phoneNum.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self showMsg:@"验证码不正确"];
    }
    
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
    [self showMsg:@"网络问题"];
}
- (void)Cancel1 {
        [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}
#pragma mark  验证格式是否正确
-(BOOL)checkPassWD:(NSString *)passwd
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    if ([passwd isMatchedByRegex:MOBILE]) {
        return YES;
    }
    else if([passwd isMatchedByRegex:CM])
    {
        return YES;
    }
    else if ([passwd isMatchedByRegex:CU])
    {
        return YES;
    }
    return NO;
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
