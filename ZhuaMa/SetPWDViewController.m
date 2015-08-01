//
//  SetPWDViewController.m
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SetPWDViewController.h"
#import "RegexKitLite.h"
@interface SetPWDViewController ()
{
    UITextField *NewPWD;
    UITextField *AgainPWD;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@end

@implementation SetPWDViewController

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
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"请重设你的密码" font:15];
    [self.view addSubview:tishi];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [self.view addSubview:bgView];
    

    AgainPWD = [MyControll createTextFieldWithFrame:CGRectMake(20, 55, WIDTH-130, 40) text:nil placehold:@"请输入新密码" font:15];
    [bgView addSubview:AgainPWD];
    UIView *line = [MyControll createViewWithFrame:CGRectMake(0, 50, WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [bgView addSubview:line];
    
    
    NewPWD = [MyControll createTextFieldWithFrame:CGRectMake(20, 5, WIDTH-30, 40) text:nil placehold:@"输入短信验证码" font:15];
    [bgView addSubview:NewPWD];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 180, 260, 50) bgImageName:nil imageName:@"wanc@2x" title:nil selector:@selector(commitClick) target:self];
    [self.view addSubview:commit];
    
}
-(void)commitClick
{
    if (![self checkPassWD:NewPWD.text]) {
        [self showMsg:@"密码格式不对"];
        return;
    }
    else if (![AgainPWD.text isEqualToString:NewPWD.text])
    {
        [self showMsg:@"密码不一致"];
        return;
    }
    [self loadData];
}
-(void)loadData
{
    [self.view endEditing:YES];
    if(_mDownManager)
    {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@forget?mobile=%@&newpwd=%@",SERVER_URL,_phoneNum,NewPWD.text];
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
        [self showMsg:@"密码修改成功"];
        [self performSelector:@selector(GoBack1) withObject:self afterDelay:1];
    }
}
-(void)GoBack1
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark  验证格式是否正确
-(BOOL)checkPassWD:(NSString *)passwd
{
    NSString * regexString = @"^[a-zA-Z0-9]{6,20}+$";
    BOOL isYes = [passwd isMatchedByRegex:regexString];
    return isYes;
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
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
