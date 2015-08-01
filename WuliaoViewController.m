//
//  WuliaoViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/28.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "WuliaoViewController.h"
#import "PlaceSelectView.h"
#import "TTTSelectView.h"
#import "TimeSelectView.h"
#import "PicSelectView.h"
#import "ASIDownManager.h"
@interface WuliaoViewController ()<placeSelectDelegate,TTTSelectViewDelegate,TimeSelectDelegate,UIScrollViewDelegate,UITextViewDelegate,PicSelectDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIScrollView *mainSC;
    UITextField *topic;
    UILabel *workPlace;
    UITextField *detailPlace;
    UILabel *actorType;
    UITextField *lmoney;
//    UITextField *hmoney;
    UILabel *timeLabel;
    
    NSString *pro;
    NSString *proID;
    NSString *city;
    NSString *cityID;
    NSString *subType;
    NSString *subTypeID;
    NSString *timeStr;
    
    UITextView *textView;
    UIView *secView;
    UIView *thirdView;
    int deletePicNum;
}
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)ASIDownManager *mDownManager;

@end

@implementation WuliaoViewController

-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"物料发布" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = YES;
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate = self;
    mainSC.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 760);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 15, WIDTH, 240) withColor:[UIColor whiteColor] withNameArray:@[@"主       题",@"所在地区",@"详细地址",@"物料类别",@"产品报价",@"截止时间"]];
    [mainSC addSubview:firstView];
    
    topic = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 5, WIDTH/5*4-50, 30) text:nil placehold:@"输入主题" font:14];
    [firstView addSubview:topic];
    
    workPlace = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 45, WIDTH/5*4-50, 30) title:@"所在地区" font:14];
    workPlace.textColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:workPlace];
    
    detailPlace =[MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 85, WIDTH/5*4-50, 30) text:nil placehold:@"输入详细地址" font:14];
    [firstView addSubview:detailPlace];
    
    
    actorType = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 125, WIDTH/5*4-50, 30) title:@"物料类别" font:14];
    actorType.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:actorType];
    
    lmoney = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 165, 100, 30) text:nil placehold:@"报价" font:14];
    lmoney.delegate = self;
    lmoney.layer.borderWidth = 0.5;
    lmoney.layer.borderColor = [[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]CGColor];
    lmoney.keyboardType = UIKeyboardTypeNumberPad;
    [firstView addSubview:lmoney];
    
//    UILabel *heng = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+100, 165, 20, 30) title:@"-" font:14];
//    heng.textAlignment = NSTextAlignmentCenter;
//    [firstView addSubview:heng];
//    
//    hmoney = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+120, 165, 60, 30) text:nil placehold:@"最高报价" font:14];
//    hmoney.layer.borderWidth = 0.5;
//    hmoney.layer.borderColor = [[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]CGColor];
//    hmoney.keyboardType = UIKeyboardTypeNumberPad;
//    [firstView addSubview:hmoney];
    
    UILabel *yuan = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+145, 165, 30, 30) title:@"元" font:14];
    [firstView addSubview:yuan];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 205, WIDTH/5*4-50, 30) title:@"选择截止时间" font:14];
    timeLabel.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:timeLabel];
    
    UIButton *workPlaceBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 40, WIDTH/5*4-30, 40) bgImageName:nil imageName:nil title:nil selector:@selector(selectClick:) target:self];
    workPlaceBtn.tag = 100;
    [firstView addSubview:workPlaceBtn];
    
    UIButton *actorTypeBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 120, WIDTH/5*4-30, 40) bgImageName:nil imageName:nil title:nil selector:@selector(selectClick:) target:self];
    actorTypeBtn.tag = 101;
    [firstView addSubview:actorTypeBtn];
    
    UIButton *timeBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 200, WIDTH/5*4-30, 40) bgImageName:nil imageName:nil title:nil selector:@selector(selectClick:) target:self];
    timeBtn.tag = 102;
    [firstView addSubview:timeBtn];
    
    
    secView = [MyControll createToolView2WithFrame:CGRectMake(0, 270, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"联系人",@"电话",@"邮箱",@"微信"]];
    [mainSC addSubview:secView];
    
    NSArray *placeHoldWordArray = @[@"请输入联系人姓名",@"请输入电话",@"请输入邮箱",@"请输入微信"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName  =[user objectForKey:@"name"];
    NSString *wei = [user objectForKey:@"wei"];
    NSString *email = [user objectForKey:@"email"];
    NSString *mobile = [user objectForKey:@"mobile"];
    NSArray *textArray = @[userName,mobile,email,wei];
    for (int i = 0; i<4; i++) {
        UITextField *tx = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, i*40, WIDTH/5*4-50, 40) text:textArray[i] placehold:placeHoldWordArray[i] font:14];
        tx.tag = 400+i;
        if (i==1) {
            tx.keyboardType=UIKeyboardTypeNumberPad;
        }
        [secView addSubview:tx];
    }
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 440, 100, 20) title:@"产品详情" font:14];
    [mainSC addSubview:tishi];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 470, WIDTH, 100)];
    textView.delegate = self;
    [mainSC addSubview:textView];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 580, 100, 20) title:@"添加示例图片" font:14];
    [mainSC addSubview:tishi1];
    
    thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 610, WIDTH, 80)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:thirdView];
    
    UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addPicClick) target:self];
    [thirdView addSubview:addPic];
    
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake(20, 700, WIDTH-40, 40) bgImageName:nil imageName:@"n3@2x" title:nil selector:@selector(commitClick) target:self];
    [mainSC addSubview:commit];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length>10) {
        if(range.length != 1) {
            [self showMsg:@"数字不能超过10位"];
            return NO;
        }
        return YES;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    mainSC.contentOffset = CGPointMake(0, 460);
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    mainSC.contentOffset = CGPointMake(0, 0);
}
-(void)selectClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    int index = (int)sender.tag-100;
    if (index == 0) {
        PlaceSelectView *placeSelectView = [[PlaceSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        placeSelectView.delegate = self;
        placeSelectView.tag = 200;
        [self.tabBarController.view addSubview:placeSelectView];
    }
    else if (index == 1)
    {
        TTTSelectView *tttSelectView = [[TTTSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        tttSelectView.delegate  = self;
        tttSelectView.tag = 201;
        [tttSelectView StartGetData:7];
        [self.tabBarController.view addSubview:tttSelectView];
    }
    else if (index == 2)
    {
        TimeSelectView *timeSelectView = [[TimeSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        timeSelectView.delegate = self;
        timeSelectView.tag = 202;
        [self.tabBarController.view addSubview:timeSelectView];
    }
}
-(void)placeSelect:(PlaceSelectView *)placeSelectView1 Dic:(NSDictionary *)dic Flag:(int)flag
{
    if (flag == 1) {
        proID = @"0";
        cityID = @"0";
        workPlace.text = @"全部城市";
        workPlace.textColor = [UIColor blackColor];
    }
    else if (flag == 2)
    {
        proID = [dic objectForKey:@"proID"];
        cityID = [dic objectForKey:@"cityID"];
        pro = [dic objectForKey:@"pro"];
        city = [dic objectForKey:@"city"];
        if ([pro isEqualToString:city]) {
            workPlace.text = [NSString stringWithFormat:@"%@",pro];
        }
        else{
            workPlace.text = [NSString stringWithFormat:@"%@%@",pro,city];
        }
        workPlace.textColor = [UIColor blackColor];
    }
    PlaceSelectView *placeSelectView = (PlaceSelectView *)[self.tabBarController.view viewWithTag:200];
    [placeSelectView removeFromSuperview];
}
-(void)TTTSelect:(TTTSelectView *)typeSelectView1 Dic:(NSDictionary *)dic Flag:(int)flag
{
    if (flag == 1) {
        subType= [dic objectForKey:@"subtypeName"];
        subTypeID = [dic objectForKey:@"subtypeID"];
        actorType.text = subType;
        actorType.textColor = [UIColor blackColor];
    }
    TTTSelectView *tttSelectView = (TTTSelectView *)[self.tabBarController.view viewWithTag:201];
    [tttSelectView removeFromSuperview];
}
-(void)timeSelect:(TimeSelectView *)timeSelectView1 TimeStr:(NSString *)timeStr1
{
    if (![timeStr1 isEqualToString:@"0"]) {
        timeLabel.text = timeStr1;
        timeLabel.textColor = [UIColor blackColor];
    }
    TimeSelectView *timeSelectView = (TimeSelectView*)[self.tabBarController.view viewWithTag:202];
    [timeSelectView removeFromSuperview];
}
-(void)addPicClick
{
    PicSelectView *picSelectView = [[PicSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    picSelectView.tag = 203;
    picSelectView.delegate = self;
    picSelectView.maxCount = 4-self.uploadPicArray.count;
    [self.tabBarController.view addSubview:picSelectView];
    
}
-(void)picSelect:(PicSelectView *)picSelectView1 Camera:(NSString *)filePath Album:(NSMutableArray *)array Flag:(int)flag
{
    if (flag == 1) {
        [self.uploadPicArray addObject:filePath];
        [self refreshUI];
    }
    else if (flag == 2)
    {
        [self.uploadPicArray addObjectsFromArray:array];
        [self refreshUI];
    }
    PicSelectView *picSelectView = (PicSelectView *)[self.tabBarController.view viewWithTag:203];
    [picSelectView removeFromSuperview];
}
-(void)refreshUI
{
    for (UIView *view in thirdView.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<self.uploadPicArray.count+1; i++) {
        if (i<self.uploadPicArray.count) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, 10, 60, 60) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.uploadPicArray[i]];
            [tempImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            tempImageView.tag = 300+i;
            [thirdView addSubview:tempImageView];
        }
        else if(i != 4)
        {
            UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20+i*73, 10, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addPicClick) target:self];
            [thirdView addSubview:addPic];
        }
    }
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    deletePicNum = (int)sender.view.tag-300;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除改图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.uploadPicArray removeObjectAtIndex:deletePicNum];
        [self refreshUI];
    }
}
-(void)commitClick
{
    UITextField *tx1 =(UITextField *)[secView viewWithTag:400];
    UITextField *tx2 = (UITextField *)[secView viewWithTag:401];
    if ([topic.text isEqualToString:@""]) {
        [self showMsg:@"主题不能为空"];
        return;
    }
    else if ([workPlace.text isEqualToString:@"工作地区"])
    {
        [self showMsg:@"所在地区不能为空"];
        return;
    }
    else if ([actorType.text isEqualToString:@"艺人类别"])
    {
        [self showMsg:@"物料类别不能为空"];
        return;
    }
    else if ([lmoney.text isEqualToString:@""])
    {
        [self showMsg:@"报价不能为空"];
        return;
    }
//    else if ([hmoney.text isEqualToString:@""])
//    {
//        [self showMsg:@"最高报价不能为空"];
//        return;
//    }
    else if ([timeLabel.text isEqualToString:@"选择截止时间"])
    {
        [self showMsg:@"截止时间不能为空"];
        return;
    }
    else if ([tx1.text isEqualToString:@""])
    {
        [self showMsg:@"联系人不能为空"];
        return;
    }
    else if ([tx2.text isEqualToString:@""])
    {
        [self showMsg:@"电话不能为空"];
        return;
    }
    [self loadData];
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
    UITextField *tx1 =(UITextField *)[secView viewWithTag:400];
    UITextField *tx2 = (UITextField *)[secView viewWithTag:401];
    UITextField *tx3 =(UITextField *)[secView viewWithTag:402];
    UITextField *tx4 = (UITextField *)[secView viewWithTag:403];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:topic.text forKey:@"name"];
    [dic setObject:subTypeID forKey:@"subtype"];
    [dic setObject:lmoney.text forKey:@"lmoney"];
//    [dic setObject:hmoney.text forKey:@"hmoney"];
    [dic setObject:proID forKey:@"pro"];
    [dic setObject:cityID forKey:@"city"];
    [dic setObject:detailPlace.text forKey:@"address"];
    [dic setObject:timeLabel.text forKey:@"jtime"];
    [dic setObject:tx1.text forKey:@"contact"];
    [dic setObject:tx2.text forKey:@"mobile"];
    [dic setObject:tx3.text forKey:@"email"];
    [dic setObject:tx4.text forKey:@"wei"];
    [dic setObject:textView.text forKey:@"note"];
    NSString *urlstr = [NSString stringWithFormat:@"%@careatenote2",SERVER_URL];
    
    //    NSString *urlstr = [NSString stringWithFormat:@"%@careatenote1?uid=%@&token=%@&name=%@&subtype=%@&lmoney=%@&pro=%@&city=%@&address=%@&jtime=%@&contact=%@&mobile=%@&email=%@&wei=%@&note=%@",SERVER_URL,uid,token,topic.text,subTypeID,money.text,proID,cityID,detailPlace.text,timeLabel.text,tx1.text,tx2.text,tx3.text,tx4.text,textView.text];
    self.mDownManager= [[ASIDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    //    [_mDownManager GetImageByStr:urlstr];
    if (self.uploadPicArray.count==0) {
        [ _mDownManager PostHttpRequest:urlstr :dic files:nil];
    }
    else
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i<self.uploadPicArray.count; i++) {
            [dict setObject:self.uploadPicArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
        }
        [_mDownManager PostHttpRequest:urlstr :dic files:dict];
    }
    
}
-(void)OnLoadFinish:(ASIDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count>0) {
        
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            [self showMsg:@"发布物料成功"];
            [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
    }
}
- (void)OnLoadFail:(ASIDownManager *)sender {
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
-(void)dealloc
{
    self.mDownManager.delegate = nil;
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
