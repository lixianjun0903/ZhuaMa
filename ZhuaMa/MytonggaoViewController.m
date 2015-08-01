//
//  MytonggaoViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MytonggaoViewController.h"
#import "TonggaoTableViewCell.h"
#import "MyshenqingViewController.h"
#import "MytgDetailViewController.h"
@interface MytonggaoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *navView;
    UITableView *_tableView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation MytonggaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    return NO;
//}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self createNav];
    [self createTableView];
    [self loadData];
    
}
-(void)GoBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)createNav
{
    navView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, 120, 30) imageName:@"z"];
    UIButton *btn1= [MyControll createButtonWithFrame:CGRectMake(10, 0, 50, 30) bgImageName:nil imageName:@"<#string#>" title:@"申请" selector:@selector(myShenqing:) target:self];
    btn1.tag = 2;
    btn1.selected = NO;
    
    //    [btn1 setImage:[UIImage imageNamed:@"<#string#>"] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIButton *btn2 = [MyControll createButtonWithFrame:CGRectMake(70, 0, 50, 30) bgImageName:nil imageName:@"<#string#>" title:@"通告" selector:@selector(myTonggao:) target:self];
    btn2.tag = 1;
    btn2.selected = YES;
    //    [btn2 setImage:[UIImage imageNamed:@"<#string#>"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [navView addSubview:btn1];
    [navView addSubview:btn2];
    self.navigationItem.titleView = navView;
}
-(void)myShenqing:(UIButton *)sender
{
    sender.selected = YES;
    UIButton *btn = (UIButton *)[navView viewWithTag:1];
    btn.selected = NO;
    navView.image = [UIImage imageNamed:@"y"];
    MyshenqingViewController *vc =[[MyshenqingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)myTonggao:(UIButton *)sender
{
    sender.selected = YES;
    UIButton *btn = (UIButton *)[navView viewWithTag:2];
    btn.selected = NO;
    navView.image = [UIImage imageNamed:@"z"];
}
#pragma mark  创建tableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT -64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[TonggaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MytgDetailViewController *vc = [[MytgDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark   请求数据，加载数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@myannouncements?uid=%@&token=%@",SERVER_URL,uid,token];
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
        NSLog(@"%@", array);
        [self.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    }
    else
    {
        [self showMsg:@"没有数据"];
        [_tableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
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
