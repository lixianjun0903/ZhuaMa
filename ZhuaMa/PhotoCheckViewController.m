//
//  PhotoCheckViewController.m
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PhotoCheckViewController.h"
#import "LunBoTuViewController.h"
@interface PhotoCheckViewController ()
{
    UIScrollView *mainSC;
}
@end

@implementation PhotoCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"TA的相册" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    mainSC.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainSC];
    [self refreshUI];
}
-(void)refreshUI
{
    float width = (WIDTH - 5*5)/4;
    for (int i = 0; i<self.picArray.count; i++) {
            UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(5+(width+5)*(i%4), 10+(width+5)*(i/4), width, width) imageName:nil];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            imageView.tag = 100+i;
            [mainSC addSubview:imageView];

    }
    mainSC.contentSize = CGSizeMake(WIDTH, self.picArray.count * 80);
    
}
-(void)tap:(UIGestureRecognizer *)sender
{
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:self.picArray atIndex:sender.view.tag-100];
    [self presentViewController:vc animated:NO completion:nil];
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
