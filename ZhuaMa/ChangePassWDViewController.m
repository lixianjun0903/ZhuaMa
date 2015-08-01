//
//  ChangePassWDViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/14.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ChangePassWDViewController.h"
#import "RegexKitLite.h"
@interface ChangePassWDViewController ()<UITextFieldDelegate>
{
    UITextField *oldPWDTextField;
    UITextField *newPWDTextField;
    UITextField *checkPWdTextField;
    BOOL isOK;
    UIView *bgView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@end

@implementation ChangePassWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"修改密码" font:20];
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
    bgView = [MyControll createViewWithFrame:CGRectMake(0, 20, WIDTH, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    oldPWDTextField = [MyControll createTextFieldWithFrame:CGRectMake(100, 0, WIDTH - 100 -20, 50) text:nil placehold:@"请输入原密码" font:15];
    oldPWDTextField.delegate = self;
    [bgView addSubview:oldPWDTextField];
    
    UILabel *oldLabel = [MyControll createLabelWithFrame:CGRectMake(20, 0, 70, 50) title:@"原  密  码:" font:15];
    [bgView addSubview:oldLabel];
    
    
    UIImageView *isRight = [MyControll createImageViewWithFrame:CGRectMake(WIDTH - 45, 0, 20, 50) imageName:@"56"];
    isRight.contentMode = UIViewContentModeScaleAspectFit;
    isRight.tag = 20;
    isRight.hidden = YES;
    [bgView addSubview:isRight];
    
    
    UILabel *newLabel = [MyControll createLabelWithFrame:CGRectMake(20, 50, 70, 50) title:@"新  密  码:" font:15];
    [bgView addSubview:newLabel];
    
    newPWDTextField = [MyControll createTextFieldWithFrame:CGRectMake(100, 50, WIDTH - 100-20, 50) text:nil placehold:@"请输入新密码" font:15];
    newPWDTextField.secureTextEntry = YES;
    [bgView addSubview:newPWDTextField];
    
    UILabel *checkLabel = [MyControll createLabelWithFrame:CGRectMake(20, 100, 70, 50) title:@"确认密码:" font:15];
    [bgView addSubview:checkLabel];
    
    checkPWdTextField = [MyControll createTextFieldWithFrame:CGRectMake(100, 100, WIDTH -100 - 20, 50) text:nil placehold:@"请输入确认密码" font:15];
    checkPWdTextField.secureTextEntry = YES;
    [bgView addSubview:checkPWdTextField];
    
    for (int i = 0; i<2; i++) {
        UIView *line = [MyControll createViewWithFrame:CGRectMake(20, 50*(i+1), WIDTH-20, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
        [bgView addSubview:line];
    }
    
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH - 260)/2, 200, 260, 40) bgImageName:nil imageName:@"wanc" title:nil selector:@selector(confirmClick:) target:self];
    [self.view addSubview:confirmBtn];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == oldPWDTextField) {
        [self checkOldPassWD];
    }
}
#pragma mark  验证格式是否正确
-(BOOL)checkPassWD:(NSString *)passwd
{
    NSString * regexString = @"^[a-zA-Z0-9]{6,20}+$";
    BOOL isYes = [passwd isMatchedByRegex:regexString];
    return isYes;
}
-(void)confirmClick:(UIButton *)sender
{
    if (!isOK) {
        [self showMsg:@"旧密码不正确"];
        return;
    }
    else if (![self checkPassWD:newPWDTextField.text])
    {
        [self showMsg:@"密码格式不正确"];
        return;
    }
    else if (![checkPWdTextField.text isEqualToString:newPWDTextField.text])
    {
        [self showMsg:@"密码不一致"];
        return;
    }
    [self commit];
}
-(void)checkOldPassWD
{
    if(_secDownManager)
    {
        return;
    }
//        [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@pwdiftrue?uid=%@&token=%@&pwd=%@",SERVER_URL,uid,token,oldPWDTextField.text];
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
    [self Cancel];
    if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
        NSLog(@"原密码匹配成功");
        UIImageView *isRight = (UIImageView *)[bgView viewWithTag:20];
        isRight.hidden = NO;
        isOK = YES;
    }
    else
    {
        NSLog(@"原密码不正确");
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    //    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}

-(void)commit
{
    if(_mDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@updatepwd?uid=%@&token=%@&pwd=%@",SERVER_URL,uid,token,newPWDTextField.text];
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
        NSLog(@"修改成功");
        [self showMsg:@"密码修改成功"];
        [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
    }
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
