//
//  InviteViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/28.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "InviteViewController.h"
#import "TimeSelectView.h"
#import "PlaceSelectView.h"
#import "PicSelectView.h"
#import "ASIDownManager.h"
@interface InviteViewController ()<placeSelectDelegate,TimeSelectDelegate,UITextViewDelegate,PicSelectDelegate,UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UITextField *topic;
    UILabel *workPlace;
    UITextField *detailPlace;
    UILabel *timeLabel;
    
    NSString *pro;
    NSString *proID;
    NSString *city;
    NSString *cityID;
    
    UIView *secView;
    UIView *thirdView;
    UIView *fourView;
    UIView *fifthView;
    
    UITextField *inviteCount;
    UITextView *textView;
    int deletePicNum;
    int paytype;
    int sexType;
    int subtype;
}
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)ASIDownManager *mDownManager;
@end

@implementation InviteViewController
-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    subtype = 1;
    sexType = 2;
    paytype = 1;
     self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"创建邀约" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = YES;
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 980);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 15, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"主       题",@"聚会时间",@"聚会地点",@"详细地址"]];
    [mainSC addSubview:firstView];
    
    topic = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 5, WIDTH/5*4-50, 30) text:nil placehold:@"输入主题" font:14];
    [firstView addSubview:topic];
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 45, WIDTH/5*4-50, 30) title:@"请选择时间" font:14];
    timeLabel.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:timeLabel];
    
    workPlace = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 85, WIDTH/5*4-50, 30) title:@"聚会地点" font:14];
    workPlace.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:workPlace];
    
    detailPlace = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 125, WIDTH/5*4-50, 30) text:nil placehold:@"请输入详细地址" font:14];
    [firstView addSubview:detailPlace];
    
    for ( int i = 0; i<2; i++) {
        UIButton *firstBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 40+i*40, WIDTH/5*4-30, 40) bgImageName:nil imageName:nil title:nil selector:@selector(firstViewClick:) target:self];
        firstBtn.tag = 100+i;
        [firstView addSubview:firstBtn];
    }
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 185, 100, 20) title:@"邀约形式" font:14];
    [mainSC addSubview:tishi];
    
    secView = [[UIView alloc]initWithFrame:CGRectMake(0, 215, WIDTH, 90)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
//    float width = (WIDTH-40)/6;
    float subWidth = (WIDTH-40-6*40)/5;
    NSArray *deSelectArray = @[@"14@2x_22",@"14@2x_23",@"14@2x_24",@"14@2x_21",@"14@2x_25",@"14@2x_26"];
    NSArray *selectArray = @[@"14@2x_03",@"14@2x_05",@"14@2x_07",@"14@2x_09",@"14@2x_11",@"14@2x_13"];
    NSArray *titleArray = @[@"喝咖啡",@"吃饭",@"看电影",@"唱歌",@"运动",@"见面聊"];
    for (int i = 0; i<6; i++) {
        UIButton *secBtn = [MyControll createButtonWithFrame:CGRectMake(20+(subWidth+40)*i, 10, 40, 40) bgImageName:nil imageName:deSelectArray[i] title:nil selector:@selector(secViewClick:) target:self];
        [secBtn setImage:[UIImage imageNamed:selectArray[i]] forState:UIControlStateSelected];
        secBtn.tag = 300+i;
        [secView addSubview:secBtn];
        
        if (i==0) {
            secBtn.selected = YES;
        }
        UILabel *nameLabel = [MyControll createLabelWithFrame:CGRectMake(20+(subWidth+40)*i, 60, 40, 20) title:titleArray[i] font:12];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor colorWithRed:0.66f green:0.66f blue:0.66f alpha:1.00f];
        [secView addSubview:nameLabel];
    }
    
    
    thirdView = [MyControll createToolView2WithFrame:CGRectMake(0, 325, WIDTH, 120) withColor:[UIColor whiteColor] withNameArray:@[@"邀约对象",@"付费形式",@"邀约人数"]];
    [mainSC addSubview:thirdView];
    
    NSArray *sexArray = @[@"女",@"男",@"不限"];
    
    for (int i = 0; i<3; i++) {
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+80+i*60, 5, 40, 30) title:sexArray[i] font:15];
        [thirdView addSubview:label];
        
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+40+ i*60, 5, 40, 30) bgImageName:nil imageName:@"57" title:nil selector:@selector(sexClick:) target:self];
        [btn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
        btn.tag = 400+i;
        [thirdView addSubview:btn];
        
        if (i==2) {
            btn.selected = YES;
        }
        
       
    }
    
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"我请客",@"AA",@"你请客"]];
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(segSelect:) forControlEvents:UIControlEventValueChanged];
    seg.frame = CGRectMake(WIDTH/5+40, 45, WIDTH/5*4-50, 30);
    seg.tintColor = [UIColor colorWithRed:0.98f green:0.60f blue:0.24f alpha:1.00f];
    [thirdView addSubview:seg];
    
    
    inviteCount = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 85, WIDTH/5*4-50, 30) text:nil placehold:@"邀约人数" font:14];
    inviteCount.keyboardType = UIKeyboardTypeNumberPad;
    [thirdView addSubview:inviteCount];
    
    
    fourView = [MyControll createToolView2WithFrame:CGRectMake(0, 465, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"联系人",@"电话",@"邮箱",@"微信"]];
    [mainSC addSubview:fourView];
    
    NSArray *placeHoldWordArray = @[@"请输入联系人姓名",@"请输入电话",@"请输入邮箱",@"请输入微信"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName  =[user objectForKey:@"name"];
    NSString *wei = [user objectForKey:@"wei"];
    NSString *email = [user objectForKey:@"email"];
    NSString *mobile = [user objectForKey:@"mobile"];
    NSArray *textArray = @[userName,mobile,email,wei];
    for (int i = 0; i<4; i++) {
        UITextField *tx = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, i*40, WIDTH/5*4-50, 40) text:textArray[i] placehold:placeHoldWordArray[i] font:14];
        tx.tag = 500+i;
        if (i==1) {
            tx.keyboardType=UIKeyboardTypeNumberPad;
        }
        [fourView addSubview:tx];
    }

    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 635, 100, 20) title:@"邀约详情" font:14];
    [mainSC addSubview:tishi1];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 665, WIDTH, 100)];
    textView.delegate = self;
    [mainSC addSubview:textView];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(20, 775, 100, 20) title:@"添加示例图片" font:14];
    [mainSC addSubview:tishi2];
    
    fifthView = [[UIView alloc]initWithFrame:CGRectMake(0, 815, WIDTH, 80)];
    fifthView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:fifthView];
    
    UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addPicClick) target:self];
    [fifthView addSubview:addPic];
    
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake(20, 910, WIDTH-40, 40) bgImageName:nil imageName:@"n3@2x" title:nil selector:@selector(commitClick) target:self];
    [mainSC addSubview:commit];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    mainSC.contentOffset = CGPointMake(0, 650);
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    mainSC.contentOffset = CGPointMake(0, 0);
}
-(void)segSelect:(UISegmentedControl *)sender
{
    paytype = sender.selectedSegmentIndex+1;
}
-(void)sexClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    for (int i = 0; i<3; i++) {
        UIButton *btn = (UIButton *)[thirdView viewWithTag:400+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            sexType = btn.tag-400;
        }
        else
        {
            btn.selected = NO;
        }
    }
}
-(void)secViewClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    for (int i = 0; i<6; i++) {
        UIButton *btn = (UIButton *)[secView viewWithTag:300+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            subtype = btn.tag-300+1;
        }
        else
        {
            btn.selected = NO;
        }
    }
}
-(void)firstViewClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    int index = (int)sender.tag-100;
    if (index == 0) {
        TimeSelectView *timeSelectView = [[TimeSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        timeSelectView.delegate = self;
        timeSelectView.tag = 200;
        [self.tabBarController.view addSubview:timeSelectView];
    }
    else if (index ==1)
    {
        PlaceSelectView *placeSelectView = [[PlaceSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        placeSelectView.delegate = self;
        placeSelectView.tag = 201;
        [self.tabBarController.view addSubview:placeSelectView];
    }
}
-(void)timeSelect:(TimeSelectView *)timeSelectView1 TimeStr:(NSString *)timeStr1
{
    if (![timeStr1 isEqualToString:@"0"]) {
        timeLabel.text = timeStr1;
        timeLabel.textColor = [UIColor blackColor];
    }
    TimeSelectView *timeSelectView = (TimeSelectView*)[self.tabBarController.view viewWithTag:200];
    [timeSelectView removeFromSuperview];
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
    PlaceSelectView *placeSelectView = (PlaceSelectView *)[self.tabBarController.view viewWithTag:201];
    [placeSelectView removeFromSuperview];
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
    for (UIView *view in fifthView.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<self.uploadPicArray.count+1; i++) {
        if (i<self.uploadPicArray.count) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, 10, 60, 60) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.uploadPicArray[i]];
            [tempImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            tempImageView.tag = 600+i;
            [fifthView addSubview:tempImageView];
        }
        else if(i != 4)
        {
            UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20+i*73, 10, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addPicClick) target:self];
            [fifthView addSubview:addPic];
        }
    }
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    deletePicNum = (int)sender.view.tag-600;
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
    UITextField *tx1 =(UITextField *)[fourView viewWithTag:500];
    UITextField *tx2 = (UITextField *)[fourView viewWithTag:501];
    if ([topic.text isEqualToString:@""]) {
        [self showMsg:@"主题不能为空"];
        return;
    }
    else if ([workPlace.text isEqualToString:@"工作地区"])
    {
        [self showMsg:@"所在地区不能为空"];
        return;
    }
    else if ([timeLabel.text isEqualToString:@"请选择时间"])
    {
        [self showMsg:@"时间不能为空"];
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
    UITextField *tx1 =(UITextField *)[fourView viewWithTag:500];
    UITextField *tx2 = (UITextField *)[fourView viewWithTag:501];
    UITextField *tx3 =(UITextField *)[fourView viewWithTag:502];
    UITextField *tx4 = (UITextField *)[fourView viewWithTag:503];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:topic.text forKey:@"name"];
    [dic setObject:proID forKey:@"pro"];
    [dic setObject:cityID forKey:@"city"];
    [dic setObject:detailPlace.text forKey:@"address"];
    [dic setObject:timeLabel.text forKey:@"jtime"];
    [dic setObject:tx1.text forKey:@"contact"];
    [dic setObject:tx2.text forKey:@"mobile"];
    [dic setObject:tx3.text forKey:@"email"];
    [dic setObject:tx4.text forKey:@"wei"];
    [dic setObject:textView.text forKey:@"note"];
    [dic setObject:[NSString stringWithFormat:@"%d",paytype] forKey:@"paytype"];
    [dic setObject:[NSString stringWithFormat:@"%d",sexType] forKey:@"sex"];
    [dic setObject:[NSString stringWithFormat:@"%d",subtype] forKey:@"subtype"];
    [dic setObject:inviteCount.text forKey:@"num"];
    NSString *urlstr = [NSString stringWithFormat:@"%@careatenote4",SERVER_URL];
    
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
            [self showMsg:@"创建邀约成功"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
