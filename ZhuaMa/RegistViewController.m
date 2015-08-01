//
//  RegistViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RegistViewController.h"
#import "Regist2ViewController.h"
#import "RegexKitLite.h"
#import "ProtocolViewController.h"
@interface RegistViewController ()
{
    UITextField *tx;
}
@end

@implementation RegistViewController
-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"注册新用户" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self makeUI];
}
-(void)GoBack
{
    [self.navigationController popViewControllerAnimated:YES];
    [tx resignFirstResponder];
}
-(void)makeUI
{
    UIView *bgView = [MyControll createViewWithFrame:CGRectMake(0, 20, WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    tx = [MyControll createTextFieldWithFrame:CGRectMake(20, 5, WIDTH-40, 40) text:nil placehold:@"输入手机号" font:16];
    [bgView addSubview:tx];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 80, WIDTH-40, 20) title:@"通过手机号可以帮你找到有价值的人或者认识的人" font:13];
    tishi.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tishi];

    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(20, 110, WIDTH-40, 40) title:@"点击“下一步”按钮代表已阅读并同意\n《抓马软件许可及服务协议》" font:12];
    [self.view addSubview:tishi2];
    
    
    CGSize size = [MyControll getSize:tishi2.text Font:12 Width:WIDTH-40 Height:100];
    tishi2.frame = CGRectMake(20, 110, size.width, size.height);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tishi2.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.25f green:0.36f blue:0.51f alpha:1.00f] range:NSMakeRange(19,11)];
    tishi2.attributedText = str;
    
    tishi2.userInteractionEnabled =YES;
    [tishi2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToInfo)]];
    
    UIButton *nextBtn = [MyControll createButtonWithFrame:CGRectMake(20, 160, WIDTH-40, 40) bgImageName:nil imageName:@"44" title:nil selector:@selector(nextClick) target:self];
    [self.view addSubview:nextBtn];
   
}
-(void)goToInfo
{
    ProtocolViewController *vc = [[ProtocolViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)nextClick
{
    if (![self checkPassWD:tx.text]) {
        [self showMsg:@"格式不正确"];
        return;
    }
    Regist2ViewController *vc =[[Regist2ViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.phoneNum = [NSString stringWithFormat:@"%@",tx.text];
    [self.navigationController pushViewController:vc animated:YES];
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
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController  setNavigationBarHidden:NO];
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
