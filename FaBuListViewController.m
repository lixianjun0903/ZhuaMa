//
//  FaBuListViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "FaBuListViewController.h"
#import "ActorViewController.h"
#import "WuliaoViewController.h"
#import "SkillViewController.h"
#import "InviteViewController.h"
#import "RaiseMoneyViewController.h"
@interface FaBuListViewController ()<UIScrollViewDelegate>
{
    UIScrollView *mainSC;
    UIScrollView *lunBoSC;
    UIPageControl *pageControll;
}
@end

@implementation FaBuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"发布信息" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [self.view addSubview:mainSC];
    
    lunBoSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 130)];
    lunBoSC.showsHorizontalScrollIndicator = NO;
    lunBoSC.delegate = self;
    lunBoSC.pagingEnabled = YES;
    [mainSC addSubview:lunBoSC];
    pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH/2+10, 90, WIDTH/2-10, 40)];
    [mainSC addSubview:pageControll];
    [self loadData];
    NSArray *btnArray = @[@"111@2x_03",@"111@2x_06",@"111@2x_10",@"111@2x_13",@"111@2x_08"];
    for (int i = 0; i<5; i++) {
        UIButton *fabuBtn = [MyControll createButtonWithFrame:CGRectMake(20, 145+75*i, WIDTH-40, 60) bgImageName:nil imageName:btnArray[i] title:nil selector:@selector(fabuClick:) target:self];
        fabuBtn.tag = 100+i;
        [mainSC addSubview:fabuBtn];
    }
    mainSC.contentSize = CGSizeMake(WIDTH, 530);
}
-(void)fabuClick:(UIButton *)sender
{
    int index = (int)sender.tag-100;
    if (index == 0) {
        ActorViewController *vc = [[ActorViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        WuliaoViewController *vc = [[WuliaoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2)
    {
        SkillViewController *vc = [[SkillViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 3)
    {
        InviteViewController *vc = [[InviteViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index ==4)
    {
        RaiseMoneyViewController *vc = [[RaiseMoneyViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControll.currentPage = (scrollView.contentOffset.x+5)/scrollView.frame.size.width;
    
}
-(void)refreshUI
{
    pageControll.numberOfPages = self.dataArray.count;
    pageControll.currentPage = 0;
    lunBoSC.contentSize = CGSizeMake(WIDTH*self.dataArray.count, 130);
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, 130) imageName:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i][@"image"]]];
        [lunBoSC addSubview:imageView];
        
        UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(10, 110, lunBoSC.frame.size.width-100, 20) title:self.dataArray[i][@"name"] font:10];
        titleLabel.textColor = [UIColor whiteColor];
        [imageView addSubview:titleLabel];
        
    }

}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@artlist?limit=10&page=1&type=9",SERVER_URL];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [self refreshUI];
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
