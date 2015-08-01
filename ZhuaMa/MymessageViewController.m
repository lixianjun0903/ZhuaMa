//
//  MymessageViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MymessageViewController.h"
#import "MessageView.h"
#import "HaoyoushenqingView.h"
@interface MymessageViewController ()
{
    UIImageView *topNav;

    
    MessageView *messageView;
    HaoyoushenqingView *haoyoushenqingView;
}
@end

@implementation MymessageViewController

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的消息" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self createTopNav];
    [self makeLeft];


    // Do any additional setup after loading the view.
}
#pragma mark  创建TopNav
-(void)createTopNav
{
    topNav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    topNav.image = [UIImage imageNamed:@"45"];
    topNav.userInteractionEnabled = YES;
    [self.view addSubview:topNav];
    
    UIButton *AnDetailBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH/2, 40) bgImageName:nil imageName:nil title:@"消息" selector:@selector(detailBtn:) target:self];
    [AnDetailBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    AnDetailBtn.tag = 10;
    AnDetailBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    AnDetailBtn.selected = YES;
    [topNav addSubview:AnDetailBtn];
    UIButton *haoyouBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, 40) bgImageName:nil imageName:nil title:@"好友申请" selector:@selector(detailBtn:) target:self];
    [haoyouBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    haoyouBtn.tag = 11;
    haoyouBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [topNav addSubview:haoyouBtn];
    
    UIImageView *bottomLine = [MyControll createImageViewWithFrame:CGRectMake((WIDTH/2 - 120)/2, 37, 120, 3) imageName:@"46"];
    bottomLine.tag = 15;
    [topNav addSubview:bottomLine];
    
}
-(void)detailBtn:(UIButton *)sender
{
    int index = (int)sender.tag -10;
    NSLog(@"%d",index);
    UIButton *btn0 = (UIButton *)[topNav viewWithTag:10];
    UIButton *btn1 = (UIButton *)[topNav viewWithTag:11];
    NSArray *tempArray = @[btn0,btn1];
    for (UIButton *btn in tempArray) {
        if (btn.tag - 10 == index) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    UIImageView *bottomLine = (UIImageView *)[topNav viewWithTag:15];
    [UIView animateWithDuration:0.3 animations:^{
        bottomLine.frame = CGRectMake(WIDTH/2 * index + (WIDTH/2 - 120)/2, 37, 120, 3);
    }];
    if (index == 0) {
        messageView.hidden = NO;
        if (haoyoushenqingView) {
             haoyoushenqingView.hidden = YES;
        }
    }
    else if(index == 1)
    {
        messageView.hidden = YES;
        if (haoyoushenqingView == nil) {
            [self makeRight];
            haoyoushenqingView.hidden = NO;
        }
        else
        {
            haoyoushenqingView.hidden = NO;
        }
    }
    
}
-(void)makeLeft
{
    messageView = [[MessageView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 40 - 64)];
    [self.view addSubview:messageView];
    messageView.delegate = self;
    messageView.hidden = NO;
}
-(void)makeRight
{
    haoyoushenqingView = [[HaoyoushenqingView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 40 -64)];
    [self.view addSubview:haoyoushenqingView];
    haoyoushenqingView.delegate = self;
    haoyoushenqingView.hidden = YES;
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
