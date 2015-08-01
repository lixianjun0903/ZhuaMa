//
//  LoginViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RegexKitLite.h"
#import "xllAppDelegate.h"
#import "ForgetPWDViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *userName;
    UITextField *passWD;
    BOOL isOK;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    
    
    isOK = NO;
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"登录" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *zhuce = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"注册" selector:@selector(zhuce) target:self];
    [zhuce setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:zhuce];
    [self makeUI];
}
-(void)GoBack
{
    [self.navigationController popViewControllerAnimated:YES];
    [self tap:nil];
}
-(void)zhuce
{
    RegistViewController *vc = [[RegistViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark  主UI
-(void)makeUI
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [user objectForKey:@"mobile"];
    
    UIView *firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 20, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"手机号码",@"密       码"]];
    [self.view addSubview:firstView];
    NSArray *placeHold = @[@"请输入手机号码",@"请输入密码6-20位数字或字母"];
    userName = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+20+10, 10, WIDTH/5*4 - 20 - 30, 30) text:mobile placehold:placeHold[0] font:15];
//    userName.delegate = self;
    passWD = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+20+10, 10 + 50*1, WIDTH/5*4 - 20 - 30, 30) text:nil placehold:placeHold[1] font:15];
    passWD.secureTextEntry = YES;
    [firstView addSubview:userName];
    [firstView addSubview:passWD];
    
    UIButton *forgetPassWD = [MyControll createButtonWithFrame:CGRectMake(WIDTH-100, 130, 80, 20) bgImageName:nil imageName:nil title:@"忘记密码？" selector:@selector(forgetPWD) target:self];
    forgetPassWD.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgetPassWD setTitleColor:[UIColor colorWithRed:0.25f green:0.36f blue:0.51f alpha:1.00f] forState:UIControlStateNormal];
    forgetPassWD.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:forgetPassWD];
    
    
    UIButton *loginBtn = [MyControll createButtonWithFrame:CGRectMake(20, 170, WIDTH-40, 40) bgImageName:nil imageName:@"39" title:nil selector:@selector(loginClick) target:self];
    [self.view addSubview:loginBtn];
}
-(void)forgetPWD
{
    ForgetPWDViewController *vc = [[ForgetPWDViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loginClick
{

        if (![self checkPassWD:userName.text]) {
            [self showMsg:@"手机格式不正确"];
            [userName becomeFirstResponder];
            return;
        }
        else
        {
            isOK = YES;
        }

    [userName resignFirstResponder];
    [passWD resignFirstResponder];
    if (!isOK) {
        return;
    }
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken  =  [user objectForKey:@"deviceToken"];
    NSString *urlstr = [NSString stringWithFormat:@"%@login?mobile=%@&pwd=%@&devicetoken=%@",SERVER_URL,userName.text,passWD.text,@"xielele"];
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
    if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"]) {
       NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:dict[@"token"] forKey:@"token"];
        [user setObject:userName.text forKey:@"mobile"];
        [user setObject:passWD.text forKey:@"passwd"];
        [user setObject:dict[@"uid"] forKey:@"uid"];
        [user setObject:dict[@"list"][@"name"] forKey:@"name"];
        [user setObject:dict[@"list"][@"wei"] forKey:@"wei"];
        [user setObject:dict[@"list"][@"email"] forKey:@"email"];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//        [dic setObject:userName.text forKey:@"mobile"];
        [user setObject:[dict[@"upload"] stringValue]forKey:@"upload"];
//        [user setObject:dic forKey:@"isUpload"];

        [user synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
        
        xllAppDelegate *myDelegate = (xllAppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController *homeVC = myDelegate.homeVC;
        homeVC = [[HomeViewController alloc]init];
        myDelegate.window.rootViewController = homeVC;
    }
    else
    {
        [self showMsg:dict[@"msg"]];
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {    
    [self Cancel];
    [self showMsg:@"登录失败"];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
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
