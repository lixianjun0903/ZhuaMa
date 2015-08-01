//
//  TagsViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/23.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TagsViewController.h"

@interface TagsViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UIView *biaoqianView;
    
    BOOL deleteState;
    int num;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    deleteState = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.94f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 100, 35) title:@"个人标签" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"确定" selector:@selector(confirmClick) target:self];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmBtn];
    [self makeUI];
}
-(void)confirmClick
{
    
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainSC];
    
    
    UILabel *tishiLabel1 = [MyControll createLabelWithFrame:CGRectMake(20, 20, WIDTH/2, 20) title:@"个人标签选择" font:14];
    tishiLabel1.textColor = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
    [mainSC addSubview:tishiLabel1];
    biaoqianView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, WIDTH, 20)];
    [mainSC addSubview:biaoqianView];
    [self refreshUI];
}
-(void)refreshUI
{
//    NSArray *biaoqianArray = [NSMutableArray arrayWithArray:_dataArray];
    float width = 0;
    int row = 0;
    if (_dataArray.count>0) {
        for (int i = 0; i<_dataArray.count; i++) {
                NSString *str =_dataArray[i][@"tag"];
                CGSize size = [MyControll getSize:str Font:16 Width:150 Height:20];
            if (width+size.width+50>WIDTH-40) {
                row = row+1;
                width = 0;
            }
            UILabel *bqLabel = [MyControll createLabelWithFrame:CGRectMake(20+width,15+row*60, size.width+30, 40) title:[NSString stringWithFormat:@"%@",str] font:16];
            bqLabel.backgroundColor = [UIColor whiteColor];
            bqLabel.layer.cornerRadius = 2;
            bqLabel.clipsToBounds = YES;
            bqLabel.layer.borderColor = [[UIColor colorWithRed:0.79f green:0.79f blue:0.82f alpha:1.00f]CGColor];
            bqLabel.layer.borderWidth = 0.5;
            bqLabel.textAlignment = NSTextAlignmentCenter;
            bqLabel.textColor =[UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
            bqLabel.tag = 10000+i;
            bqLabel.userInteractionEnabled = YES;
            [bqLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [biaoqianView addSubview:bqLabel];
            width = width + size.width + 50;
                }
            }
    if (_dataArray.count>0) {
        
        biaoqianView.frame = CGRectMake(0, 60, WIDTH, 20 + 20 + (row+1) * 40 + (row)*20);
    }

    mainSC.contentSize = CGSizeMake(WIDTH, biaoqianView.frame.origin.y+biaoqianView.frame.size.height+20);
}
-(void)longPress:(UIGestureRecognizer *)sender
{
        num = sender.view.tag-10000;
    if (sender.state == UIGestureRecognizerStateBegan) {
        deleteState = !deleteState;
        if (deleteState) {
                UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(sender.view.frame.origin.x+sender.view.frame.size.width-30, sender.view.frame.origin.y-25, 60,50) bgImageName:nil imageName:@"xuanzhong" title:nil selector:@selector(btnClick:) target:self];
                btn.tag = 20000;
                [biaoqianView addSubview:btn];
        }
        else
        {
                UIButton *btn = (UIButton *)[biaoqianView viewWithTag:20000];
                [btn removeFromSuperview];
                btn =nil;
        }
    }
}
-(void)btnClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你要删掉改标签吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self commit];
    }
}
#pragma mark  完成提交
-(void)commit
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    //    [self StartLoading];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@cancletag?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,self.dataArray[num][@"id"]];
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
    
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            NSLog(@"即将删除的%@~~~~%@",self.dataArray[num][@"tag"],self.dataArray[num][@"id"]);
            [self.dataArray removeObjectAtIndex:num];
            for (UIView *view in biaoqianView.subviews) {
                [view removeFromSuperview];
            }
            deleteState = NO;
            [self refreshUI];
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
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
