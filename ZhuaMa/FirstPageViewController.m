//
//  FirstPageViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/16.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "FirstPageViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "xllAppDelegate.h"
@interface FirstPageViewController ()

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    firstImageView.image = [UIImage imageNamed:@"启动页(1).png"];
    firstImageView.userInteractionEnabled = YES;
    [self.view addSubview:firstImageView];
    UIButton *loginBtn = [MyControll createButtonWithFrame:CGRectMake(firstImageView.frame.size.width/2-145, firstImageView.frame.size.height - 100, 140, 46.3) bgImageName:nil imageName:@"dengl@2x-" title:nil selector:@selector(btn:) target:self];
    loginBtn.tag = 100;
    [firstImageView addSubview:loginBtn];
    UIButton *registBtn = [MyControll createButtonWithFrame:CGRectMake(firstImageView.frame.size.width/2+5, firstImageView.frame.size.height - 100, 140, 46.3) bgImageName:nil imageName:@"zhcue@2x-" title:nil selector:@selector(btn:) target:self];
    registBtn.tag = 101;
    [firstImageView addSubview:registBtn];
}
-(void)btn:(UIButton *)sender
{
    if (sender.tag == 100) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag == 101)
    {
        RegistViewController *vc = [[RegistViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
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
