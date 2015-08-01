//
//  SettingViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "ChangePassWDViewController.h"
#import "FeedBackViewController.h"
#import "xllAppDelegate.h"
#import "FirstPageViewController.h"
#import "contactTableViewController.h"
#import "ContactUpLoad.h"
@interface SettingViewController ()<UIAlertViewDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"设置" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self makeUI];
}
#pragma mark   主UI
-(void)makeUI
{
    UIView *firstView = [MyControll createToolViewWithFrame:CGRectMake(0, 20, WIDTH, 250) withColor:[UIColor whiteColor] withNameArray:@[@"修改密码",@"消息提醒",@"用户反馈",@"版本更新",@"联系我们"]];
    [self.view addSubview:firstView];
    for (int i = 0; i<4; i++) {
        if (i==0) {
             UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(btnClick:) target:self];
            btn.tag = 100+i;
            [firstView addSubview:btn];
        }
       else if (i>0)
       {
           UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 50+i*50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(btnClick:) target:self];
           btn.tag = 100+i;
           [firstView addSubview:btn];
       }
    }
    
    UILabel *bglabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-70, 53, 70, 45) title:nil font:0];
    [firstView addSubview:bglabel];
    bglabel.backgroundColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH - 70, 60, 50, 50)];
    sw.on = YES;
    sw.onTintColor = [UIColor orangeColor];
    [firstView addSubview:sw];
    
    UIButton *loginBtn = [MyControll createButtonWithFrame:CGRectMake(0, 290, WIDTH, 50) bgImageName:nil imageName:nil title:@"退出账户" selector:@selector(login) target:self];
    [loginBtn setBackgroundColor:[UIColor whiteColor]];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:loginBtn];
}
-(void)btnClick:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    int index = (int)sender.tag - 100;
    if (index == 0) {
        ChangePassWDViewController *vc =[[ChangePassWDViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (index == 1)
    {
        FeedBackViewController *vc = [[FeedBackViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(index == 3)
    {

    }
}
-(void)login
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"uid"];
        [user removeObjectForKey:@"token"];
        [user removeObjectForKey:@"upload"];
        [user synchronize];
        
        
        xllAppDelegate *myDelegate = (xllAppDelegate *)[[UIApplication sharedApplication] delegate];
        NavRootViewController *nav = myDelegate.loginNav;
        FirstPageViewController *vc = [[FirstPageViewController alloc]init];
        nav = [[NavRootViewController alloc]initWithRootViewController:vc];
        myDelegate.window.rootViewController = nav;
        
    }
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
