//
//  ChoseHYViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/6.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ChoseHYViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
@interface ChoseHYViewController ()
{
    UIView *bgView;
    
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation ChoseHYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectArray =[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"选择行业" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self loadData];
    

}
//-(void)GoBack
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@choiselist?type=1",SERVER_URL];
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
//    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    if (self.dataArray.count>0) {
        [self makeUI];
    }
    [self Cancel];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)makeUI
{
    UIScrollView *mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 40 + self.dataArray.count *50+50);
    [self.view addSubview:mainSC];
    
    UILabel *descLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, WIDTH-40, 20) title:@"选择行业方向" font:14];
    descLabel.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:descLabel];
    
    bgView = [MyControll createViewWithFrame:CGRectMake(0, 40, WIDTH, self.dataArray.count * 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:bgView];
    
    
    
    for (int i=0; i<self.dataArray.count; i++) {
        UILabel *hangyeLabel = [MyControll createLabelWithFrame:CGRectMake(0, 50*i, 70, 50) title:self.dataArray[i][@"value"] font:15];
        hangyeLabel.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        hangyeLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:hangyeLabel];
        
        
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 55, 50*i, 50, 50) bgImageName:nil imageName:@"57" title:nil selector:@selector(btnClick:) target:self];
        btn.tag = 100+i;
        [btn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
        [bgView addSubview:btn];
    }
    
    for (int i = 0; i<self.dataArray.count+1; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:line];
    }
}
-(void)btnClick:(UIButton *)sender
{
    BOOL isSelect = sender.selected;
    if (isSelect) {
        sender.selected = NO;
        NSString *str = self.dataArray[sender.tag-100][@"value"];
        [self.selectArray removeObject:str];
    }
    else
    {
        
        if (self.selectArray.count>=5) {
            [self showMsg:@"最多选择5项"];
            return;
        }
        NSString *str = self.dataArray[sender.tag-100][@"value"];
        [self.selectArray addObject:str];
        sender.selected = YES;
    }
    [delegate changeHY:self.selectArray];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dd
{
   
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
