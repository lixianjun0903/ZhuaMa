//
//  HomeViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "HomeViewController.h"
#import "BaoliaoViewController.h"
#import "MyInfoViewController.h"
#import "AnnounceViewController.h"
#import "TrendViewController.h"
#import "TonggaoViewController.h"
#import "NavRootViewController.h"
@interface HomeViewController ()
{
    SelectTabBar *mTabView;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        float width = self.view.frame.size.width/4;
        self.itemsArray = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i<4; i++) {
            UILabel *label =[MyControll createLabelWithFrame:CGRectMake(width*(i+1)-22, 2, 20, 20) title:nil font:10];
            label.hidden = YES;
            label.layer.cornerRadius = 10;
            label.clipsToBounds = YES;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor redColor];
            label.adjustsFontSizeToFitWidth = YES;
            [self.tabBar addSubview:label];
            [self.itemsArray addObject:label];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.tabBar.alpha = 0.60;
    TonggaoViewController *ctrl1 = [[TonggaoViewController alloc] init];
    NavRootViewController *navCtrl1 = [[NavRootViewController alloc] initWithRootViewController:ctrl1];
    TrendViewController *ctrl2 = [[TrendViewController alloc] init];
    NavRootViewController *navCtrl2 = [[ NavRootViewController alloc] initWithRootViewController:ctrl2];
    
    BaoliaoViewController *ctrl3 = [[BaoliaoViewController alloc] init];
    NavRootViewController *navCtrl3 = [[ NavRootViewController alloc] initWithRootViewController:ctrl3];
    
    _ctrl4 = [[MyInfoViewController alloc] init];
    NavRootViewController *navCtrl4 = [[ NavRootViewController alloc] initWithRootViewController:_ctrl4];

    NSArray *array = @[navCtrl1, navCtrl2, navCtrl3, navCtrl4];
    self.viewControllers = array;
    self.selectedIndex = 0;
    
    mTabView = [[SelectTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    mTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    mTabView.delegate = self;
    [self.tabBar addSubview:mTabView];
    NSLog(@"tabbar %@", self.tabBar);
    [self OnTabSelect:mTabView];

    // Do any additional setup after loading the view.
}
- (void)OnTabSelect:(SelectTabBar *)sender {
    int index = sender.miIndex;
    NSLog(@"OnTabSelect:%d", index);
    self.selectedIndex = index;
    [self.tabBar bringSubviewToFront:mTabView];
    UILabel *label = self.itemsArray[index];
    label.hidden = YES;

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
