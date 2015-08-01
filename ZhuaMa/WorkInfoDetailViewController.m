//
//  WorkInfoDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/19.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "WorkInfoDetailViewController.h"
#import "PickDateView.h"
@interface WorkInfoDetailViewController ()<UITextViewDelegate,PickDateDelegate,UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UIImageView *bottomView;
    UITextField *campanyName;
    UITextField *position;
    UITextView *content;
    UILabel *timeLabel;
    NSString *startTime;
    NSString *stopTime;
    
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager*secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@end

@implementation WorkInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    self.view.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.94f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 100, 35) title:@"工作经验" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    [self createBottomView];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    mainSC.backgroundColor =[UIColor colorWithRed:0.92f green:0.92f blue:0.94f alpha:1.00f];
    [self.view addSubview:mainSC];
    mainSC.contentSize = CGSizeMake(WIDTH, 430);
    UILabel *workTishi = [MyControll createLabelWithFrame:CGRectMake(20, 20, 160, 20) title:@"我的工作经验" font:15];
    workTishi.textColor = [UIColor colorWithRed:0.61f green:0.61f blue:0.62f alpha:1.00f];
    [mainSC addSubview:workTishi];
    
    UIView *bgView = [MyControll createToolView2WithFrame:CGRectMake(0, 50, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"公司",@"职位",@"时间"]];
    [mainSC addSubview:bgView];
    
    UILabel *descTishi = [MyControll createLabelWithFrame:CGRectMake(20, 220, 150, 20) title:@"工作经历描述" font:15];
    descTishi.textColor = [UIColor colorWithRed:0.61f green:0.61f blue:0.62f alpha:1.00f];
    [mainSC addSubview:descTishi];
    
    content = [[UITextView alloc]initWithFrame:CGRectMake(0, 250, WIDTH, 150)];
    content.delegate = self;
    content.text = self.dataDic[@"text"];
    content.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:content];
    
    
    campanyName = [MyControll createTextFieldWithFrame:CGRectMake(80, 0, WIDTH-90, 50) text:self.dataDic[@"company"] placehold:@"必填" font:15];
    campanyName.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:campanyName];
    
    position = [MyControll createTextFieldWithFrame:CGRectMake(80, 50, WIDTH-90, 50) text:self.dataDic[@"post"] placehold:@"必填" font:15];
    position.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:position];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(80, 100, WIDTH-90, 50) title:[NSString stringWithFormat:@"%@——%@",self.dataDic[@"stime"],self.dataDic[@"etime"]] font:15];
    timeLabel.textAlignment = NSTextAlignmentRight;
    
    if (!self.dataDic) {
        timeLabel.text = @"必填";
        timeLabel.textColor = [UIColor colorWithRed:0.83f green:0.83f blue:0.85f alpha:1.00f];
    }
    [bgView addSubview:timeLabel];
    
    UIButton *choseTime = [MyControll createButtonWithFrame:CGRectMake(80, 100,WIDTH-80, 50) bgImageName:nil imageName:nil title:nil selector:@selector(choseClick) target:self];
    [bgView addSubview:choseTime];
}
-(void)choseClick
{
    [self tap:nil];
    PickDateView *pickDateView = [[PickDateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    pickDateView.tag = 1000;
    pickDateView.isShowTitle = YES;
    pickDateView.titleName =@"请选择职位开始日期";
    pickDateView.delegate = self;
    pickDateView.startDate = @"1900-01-01 12:00";
    pickDateView.showDate = @"2000-01-01 12:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    pickDateView.stopDate = [formatter stringFromDate:[NSDate date]];
    [pickDateView config];
    [self.tabBarController.view addSubview:pickDateView];
}
-(void)didSelectDate:(NSString *)selectDate PickDateView:(PickDateView *)pickDateView1
{
    if (pickDateView1.tag == 1000) {
        startTime = [selectDate componentsSeparatedByString:@" "][0];
        NSLog(@"%@",selectDate);
        [self removeView];
        
        PickDateView *pickDateView = [[PickDateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        pickDateView.tag = 1001;
        pickDateView.isShowTitle = YES;
        pickDateView.titleName =@"请选择职位结束日期";
        pickDateView.delegate = self;
        pickDateView.startDate = selectDate;
        pickDateView.showDate = selectDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        pickDateView.stopDate = [formatter stringFromDate:[NSDate date]];
        [pickDateView config];
        [self.tabBarController.view addSubview:pickDateView];
    }
    else if (pickDateView1.tag == 1001)
    {
        stopTime = [selectDate componentsSeparatedByString:@" "][0];
        timeLabel.text = [NSString stringWithFormat:@"%@——%@",startTime,stopTime];
        [self removeView];
    }
}
-(void)removeView
{
    PickDateView *pickDateView = (PickDateView *)[self.tabBarController.view viewWithTag:1000];
    [pickDateView removeFromSuperview];
    pickDateView = nil;
    
    PickDateView *pickDateView1 = (PickDateView *)[self.tabBarController.view viewWithTag:1001];
    [pickDateView1 removeFromSuperview];
    pickDateView1 = nil;
}
-(void)createBottomView
{
    bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - 60 -64, WIDTH, 60) imageName:@"51"];
    bottomView.userInteractionEnabled = YES;
    bottomView.alpha = 0.9;
    bottomView.hidden = NO;
    [self.view addSubview:bottomView];
    
    UIButton *disagreeBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-120)/2, 0, 120, 60) bgImageName:nil imageName:@"shanchu" title:nil selector:@selector(bottomClick:) target:self];
        disagreeBtn.tag = 2000;
    [bottomView addSubview:disagreeBtn];
        
        
    UIButton *agreeBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2 - 120)/2+WIDTH/2, 0, 120, 60) bgImageName:nil imageName:@"baocun" title:nil selector:@selector(bottomClick:) target:self];
        agreeBtn.tag = 2001;
    [bottomView addSubview:agreeBtn];

  
}
-(void)bottomClick:(UIButton *)sender
{
    if (sender.tag == 2000) {
        if (_type == 0) {
            campanyName.text = @"";
            position.text = @"";
            content.text = @"";
            timeLabel.text = @"必填";
            timeLabel.textColor = [UIColor colorWithRed:0.83f green:0.83f blue:0.85f alpha:1.00f];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要删除该工作经历吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    else if (sender.tag == 2001)
    {
        if ([campanyName.text isEqualToString:@""]||[position.text isEqualToString:@""]||[timeLabel.text isEqualToString:@"必填"]) {
            [self showMsg:@"信息填写不全"];
            return;
        }
        else
        {
            if (_type == 0) {
                [self addData];
            }
            else
            {
                 [self loadData];
            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self cancelData];
    }
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [content resignFirstResponder];
    [campanyName resignFirstResponder];
    [position resignFirstResponder];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == content) {
        mainSC.contentOffset = CGPointMake(0, 200);
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    mainSC.contentOffset = CGPointMake(0, 0);
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
     [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];

    
    
    
    
    NSString *urlstr = [NSString stringWithFormat:@"%@updatework?uid=%@&token=%@&company=%@&post=%@&text=%@&id=%@&stime=%@&etime=%@",SERVER_URL,uid,token,campanyName.text,position.text,content.text,self.dataDic[@"id"],startTime,stopTime];
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
    if (dict&&[dict isKindOfClass:[dict class]]&&dict.count) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            [self showMsg:@"工作经历修改成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"workInfoListRefresh" object:nil];
            [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    [self showMsg:@"工作经历修改失败"];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)cancelData
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@canclework?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,self.dataDic[@"id"]];
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
    if (dict&&[dict isKindOfClass:[dict class]]&&dict.count) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            [self showMsg:@"工作经历删除成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"workInfoListRefresh" object:nil];
            [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
    [self showMsg:@"工作经历删除失败"];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}
-(void)addData
{
    if (_thirdDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@creatework?uid=%@&token=%@&company=%@&post=%@&text=%@&stime=%@&etime=%@",SERVER_URL,uid,token,campanyName.text,position.text,content.text,startTime,stopTime];
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
    if (dict&&[dict isKindOfClass:[dict class]]&&dict.count) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            [self showMsg:@"工作经历添加成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"workInfoListRefresh" object:nil];
            [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
    }
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
    [self showMsg:@"工作经历添加失败"];
}
- (void)Cancel2 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.thirdDownManager);
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
