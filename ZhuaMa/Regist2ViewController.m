//
//  Regist2ViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "Regist2ViewController.h"
#import "GetCheckMaView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RegexKitLite.h"
#import "ChoseHYViewController.h"
@interface Regist2ViewController ()<GetCheckDelegate,UITextFieldDelegate,ChoseHYDeleagte>
{
    GetCheckMaView *getCheckView;
    UIView *bgView;
    BOOL isOK;
    
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property(nonatomic,copy)NSString *hangyeType;
@end

@implementation Regist2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    isOK = NO;
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"设置密码" font:20];
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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemove)]];
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 20, WIDTH-30, 20) title:@"请输入验证码，并设置密码，姓名，和行业方向" font:13];
    tishi.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tishi];
    bgView = [MyControll createToolView2WithFrame:CGRectMake(0, 60, WIDTH, 250) withColor:[UIColor whiteColor] withNameArray:@[@"验  证  码",@"密       码",@"确认密码",@"真实姓名",@"行业方向"]];
    [ self.view addSubview:bgView];
    NSArray *tempArray = @[@"请输入验证码",@"请输入密码6-20位数字或字母",@"请输入确认密码",@"请输入真实姓名"];
    for (int i = 0; i<4; i++) {
        if (i==0) {
            UITextField *tx = [MyControll createTextFieldWithFrame:CGRectMake(20+WIDTH/5+10, i*50+10, WIDTH/5*4-30-20-80, 30) text:nil placehold:tempArray[i] font:15];
            tx.tag = 10+i;
            [bgView addSubview:tx];
            tx.delegate = self;
        }
        else
        {
            UITextField *tx = [MyControll createTextFieldWithFrame:CGRectMake(20+WIDTH/5+10, i*50+10, WIDTH/5*4-30-20, 30) text:nil placehold:tempArray[i] font:15];
            tx.tag = 10+i;
            tx.delegate = self;
            [bgView addSubview:tx];
            if (i==1||i==2) {
                tx.secureTextEntry = YES;
            }
        }
        
    }
    UIImageView *rightView = [MyControll createImageViewWithFrame:CGRectMake(WIDTH-30, 200, 20, 50) imageName:@"右箭头.png"];
    rightView.tag = 1000;
    rightView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:rightView];
    UILabel *hangyeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 120, 200, 100, 50) title:nil font:15];
    hangyeLabel.tag = 1001;
    hangyeLabel.hidden =YES;
    hangyeLabel.textAlignment = NSTextAlignmentRight;
    hangyeLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:hangyeLabel];
    
    UIButton *hangyeBtn = [MyControll createButtonWithFrame:CGRectMake(0, 200, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(hangyeClick) target:self];
    [bgView addSubview:hangyeBtn];
    
    UIImageView *isRight = [MyControll createImageViewWithFrame:CGRectMake(WIDTH - 125, 0, 20, 50) imageName:@"56"];
    isRight.contentMode = UIViewContentModeScaleAspectFit;
    isRight.tag = 20;
    isRight.hidden = YES;
    [bgView addSubview:isRight];
    //获取验证码按钮
    getCheckView = [[GetCheckMaView alloc] initWithFrame:CGRectMake(WIDTH-100, 0, 90, 50)];
    getCheckView.delegate = self;
    [bgView addSubview:getCheckView];
    
    UIButton *finishBtn = [MyControll createButtonWithFrame:CGRectMake(20, 330, WIDTH-40, 40) bgImageName:nil imageName:@"42" title:nil selector:@selector(finishClick) target:self];
    [self.view addSubview:finishBtn];
    
}
-(void)changeHY:(NSArray *)array
{
        _hangyeType =  [array JSONRepresentation];
    NSLog(@"%@",_hangyeType);
        UIImageView *rightView = (UIImageView *)[bgView viewWithTag:1000];
        rightView.hidden = YES;
        UILabel *hangyeLabel = (UILabel *)[bgView viewWithTag:1001];
        hangyeLabel.text = [NSString stringWithFormat:@"已选择%d项",(int)[array count]];
        hangyeLabel.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0; i<4; i++) {
        UITextField *tx = (UITextField *)[bgView viewWithTag:10+i];
        if(tx.tag == 10)
        {
            if (!isOK) {
                [self checkMa:tx.text];
                return;
            }
        }
    }
    
}
-(void)finishClick
{
//    UITextField *tx0 = (UITextField *)[bgView viewWithTag:10];
    UITextField *tx1 = (UITextField *)[bgView viewWithTag:11];
    UITextField *tx2 = (UITextField *)[bgView viewWithTag:12];
    UITextField *tx3 = (UITextField *)[bgView viewWithTag:13];
    UILabel *hangyeLabel = (UILabel *)[bgView viewWithTag:1001];
    if (![self checkPassWD:tx1.text]) {
        [self showMsg:@"密码格式不正确"];
        [tx1 becomeFirstResponder];
        return;
    }
    else if (![tx1.text isEqualToString:tx2.text]) {
        [self showMsg:@"密码不一致"];
        [tx2 becomeFirstResponder];
        return;
    }
    else if (!isOK)
    {
        [self showMsg:@"验证码不正确"];
//        [tx0 becomeFirstResponder];
//        return;
    }
    else if (tx3.text.length>16)
    {
        [self showMsg:@"输入字符串太长"];
        [tx3 becomeFirstResponder];
        return;
    }
    else if(hangyeLabel.text.length<=0)
    {
        [self showMsg:@"行业方向未填"];
        return;
    }
    [self commit];
}
-(void)tapRemove
{
    for (int i = 0; i<4; i++) {
        UITextField *tx = (UITextField *)[bgView viewWithTag:10+i];
        [tx resignFirstResponder];
    }
    
}
-(void)hangyeClick
{
    ChoseHYViewController *vc =[[ChoseHYViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  获取验证码
-(void)buttonClick
{
    [getCheckView startCheck];
}
-(void)getCheckMa
{
    if(_mDownManager)
    {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@sendcode?mobile=%@&type=%d",SERVER_URL,self.phoneNum,1];
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
-(void)checkMa:(NSString *)str
{
    if(_secDownManager)
    {
        return;
    }
//    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@rightcode?mobile=%@&code=%@",SERVER_URL,self.phoneNum,str];
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
        UIImageView *isRight = (UIImageView *)[bgView viewWithTag:20];
        isRight.hidden = NO;
        isOK = YES;
    }
    
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
//    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  验证格式是否正确
-(BOOL)checkPassWD:(NSString *)passwd
{
    NSString * regexString = @"^[a-zA-Z0-9]{6,20}+$";
    BOOL isYes = [passwd isMatchedByRegex:regexString];
    return isYes;
}
#pragma mark 提交
-(void)commit
{
    if(_thirdDownManager)
    {
        return;
    }
        [self StartLoading];
    UITextField *tx1 = (UITextField *)[bgView viewWithTag:11];
    UITextField *tx3 = (UITextField *)[bgView viewWithTag:13];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken  =  [user objectForKey:@"deviceToken"];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@basicregist?mobile=%@&pwd=%@&name=%@&type=%@&devicetoken=%@",SERVER_URL,self.phoneNum,tx1.text,tx3.text,_hangyeType,deviceToken];
    self.thirdDownManager= [[ImageDownManager alloc]init];
    _thirdDownManager.delegate = self;
    _thirdDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManager.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish2:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel2];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[dict[@"code"] stringValue] isEqualToString:@"1"]) {
            [self showMsg:@"注册成功,请登录"];
            [self performSelector:@selector(GoBack1) withObject:self afterDelay:2];
            
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
    }
   
}
-(void)GoBack1
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.thirdDownManager);
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
