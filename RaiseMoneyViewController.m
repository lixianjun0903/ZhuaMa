//
//  RaiseMoneyViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/28.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RaiseMoneyViewController.h"
#import "PlaceSelectView.h"
#import "ASIDownManager.h"
#import "TTTSelectView.h"
#import "ProjectStateView.h"
#import "RaiseStateView.h"
#import "ZhiweiSelectView.h"
#import "PicSelectView.h"
@interface RaiseMoneyViewController ()<placeSelectDelegate,UITextViewDelegate,UIAlertViewDelegate,TTTSelectViewDelegate,ProjectStateSelectDelegate,RaiseStateSelectDelegate,ZhiweiSelectDelegate,PicSelectDelegate,UITextFieldDelegate>
{
    UIScrollView *mainSC;
    UITextField *topic;
    UILabel *proType;
    UILabel *proState;
    UILabel *workPlace;
    UITextField *detailPlace;
    UILabel *raiseStateLabel;
    UITextField *raiseGuimo;
    UITextField *outPercent;
    UITextField *partner;
    UILabel *zhiweiLabel;
    UIView *secView;
    UIView *thirdView;
    
    
    NSString *pro;
    NSString *proID;
    NSString *city;
    NSString *cityID;
    NSString *proTypeID;
    NSString *proTypeName;
    NSString *proStateID;
    NSString *proStateName;
    NSString *raiseStateName;
    NSString *zhiweiName;
    NSString *ifCanSee;
    
    
    
    int deletePicNum;
    int deleteBPPicNum;
}
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)NSMutableArray *uploadBPArray;
@property(nonatomic,strong)ASIDownManager *mDownManager;

@end

@implementation RaiseMoneyViewController
-(void)tap:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ifCanSee = @"1";
    zhiweiName = @"";
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    self.uploadBPArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"影视融资" font:20];
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
    mainSC.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 800);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 15, WIDTH, 200) withColor:[UIColor whiteColor] withNameArray:@[@"项目名称",@"项目类型",@"项目阶段",@"所在地区",@"详细地址"]];
    [mainSC addSubview:firstView];
    
    
    topic = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 5, WIDTH/5*4-50, 30) text:nil placehold:@"项目名称" font:14];
    [firstView addSubview:topic];
    
    proType = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 45, WIDTH/5*4-50, 30) title:@"项目类型" font:14];
    proType.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:proType];
    
    proState = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 85, WIDTH/5*4-50, 30) title:@"项目阶段" font:14];
    proState.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:proState];
    
    workPlace = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 125, WIDTH/5*4-50, 30) title:@"所在地" font:14];
    workPlace.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [firstView addSubview:workPlace];
    
    detailPlace = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 165, WIDTH/5*4-50, 30) text:nil placehold:@"输入详细地址" font:14];
    [firstView addSubview:detailPlace];
    
    for (int i= 0; i<3; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 40+i*40, WIDTH/5*4-30, 40) bgImageName:nil imageName:nil title:nil selector:@selector(firstViewClick:) target:self];
        btn.tag = 100+i;
        [firstView addSubview:btn];
    }
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 230, 70, 20) title:@"项目详情" font:14];
    [mainSC addSubview:tishi];
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(90, 230, 180, 20) title:@"(可添加Logo和示意图片)" font:13];
    tishi2.textColor =[UIColor colorWithRed:0.68f green:0.67f blue:0.69f alpha:1.00f];
    [mainSC addSubview:tishi2];
    
    secView = [[UIView alloc]initWithFrame:CGRectMake(0, 260, WIDTH, 80)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addPicClick) target:self];
    [secView addSubview:addPic];
    
    thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 355, WIDTH, 120)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:thirdView];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 140, 20) title:@"添加商业计划图片" font:14];
    [thirdView addSubview:tishi3];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"所有人可见",@"投资人可见"]];
    seg.frame = CGRectMake(WIDTH-180, 5, 160, 30);
    seg.selectedSegmentIndex = 0;
    seg.tintColor = [UIColor colorWithRed:0.98f green:0.56f blue:0.00f alpha:1.00f];
    [seg addTarget:self action:@selector(segSelect:) forControlEvents:UIControlEventValueChanged];
    [thirdView addSubview:seg];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [thirdView addSubview:line];
    
    UIButton *addBPPic = [MyControll createButtonWithFrame:CGRectMake(20, 50, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addBPPicClick) target:self];
    [thirdView addSubview:addBPPic];
    
    
    UIView *fourView = [MyControll createToolView4WithFrame:CGRectMake(0, 490, WIDTH, 120) withColor:[UIColor whiteColor] withNameArray:@[@"融资阶段",@"融资规模(万)",@"出让股份比例(%)"]];
    [mainSC addSubview:fourView];
    
    raiseStateLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 5, WIDTH/5*4-50, 30) title:@"融资阶段" font:14];
    raiseStateLabel.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [fourView addSubview:raiseStateLabel];
    
    raiseGuimo = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/2-20, 45, WIDTH/2-10, 30) text:nil placehold:@"融资规模" font:14];
    raiseGuimo.delegate = self;
    raiseGuimo.keyboardType = UIKeyboardTypeNumberPad;
    [fourView addSubview:raiseGuimo];
    
    outPercent = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/2, 85, WIDTH/2-10, 30) text:nil placehold:@"出让股份比例" font:14];
    outPercent.delegate = self;
    outPercent.keyboardType = UIKeyboardTypeDefault;
    [fourView addSubview:outPercent];

    UIButton *button= [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 0, WIDTH/5*4-30, 30) bgImageName:nil imageName:nil title:nil selector:@selector(fourViewClick) target:self];
    [fourView addSubview:button];
    
    
    UIView *fifthView = [MyControll createToolView2WithFrame:CGRectMake(0, 625, WIDTH, 80) withColor:[UIColor whiteColor] withNameArray:@[@"团队成员",@"职       位"]];
    [mainSC addSubview:fifthView];
    
    partner = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 5, WIDTH/5*4-50, 30) text:nil placehold:@"团队成员" font:14];
    partner.delegate = self;
    [fifthView addSubview:partner];
    
    zhiweiLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 45, WIDTH/5*4-50, 30) title:@"职位" font:14];
    zhiweiLabel.textColor =[UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    [fifthView addSubview:zhiweiLabel];
    UIButton *zhiweiBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+30, 40, WIDTH/5*4-30, 40) bgImageName:nil imageName:nil title:nil selector:@selector(fifthViewClick) target:self];
    [fifthView addSubview:zhiweiBtn];
    
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake(20, 730, WIDTH-40, 40) bgImageName:nil imageName:@"n3@2x" title:nil selector:@selector(commitClick) target:self];
    [mainSC addSubview:commit];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    mainSC.contentOffset = CGPointMake(0, 490);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    mainSC.contentOffset = CGPointMake(0, mainSC.contentSize.height-HEIGHT-64);
}
-(void)segSelect:(UISegmentedControl *)sender
{
    [self.view endEditing:YES];
    if (sender.selectedSegmentIndex == 0) {
        ifCanSee = @"1";
    }
    else
    {
        ifCanSee = @"2";
    }
}
-(void)fifthViewClick
{
    [self.view endEditing:YES];
    ZhiweiSelectView *zhiweiSelectView = [[ZhiweiSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    zhiweiSelectView.delegate = self;
    [zhiweiSelectView loadData];
    [self.tabBarController.view addSubview:zhiweiSelectView];
}
-(void)selectZhiwei:(NSString *)zhiwei ID:(NSString *)id
{
    zhiweiName =zhiwei;
    zhiweiLabel.text = zhiweiName;
    zhiweiLabel.textColor = [UIColor blackColor];
}
-(void)fourViewClick
{
    [self.view endEditing:YES];
    RaiseStateView *raiseStateView = [[RaiseStateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    raiseStateView.delegate = self;
    [raiseStateView loadData];
    [self.tabBarController.view addSubview:raiseStateView];
}
-(void)selectRaiseState:(NSString *)raiseState ID:(NSString *)id
{
    raiseStateName = raiseState;
    raiseStateLabel.text = raiseStateName;
    raiseStateLabel.textColor = [UIColor blackColor];
}

#pragma mark  添加图片处理
-(void)addPicClick
{
    [self.view endEditing:YES];
    PicSelectView *picSelectView = [[PicSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    picSelectView.tag = 900;
    picSelectView.delegate = self;
    picSelectView.maxCount = 4-self.uploadPicArray.count;
    [self.tabBarController.view addSubview:picSelectView];
}
-(void)addBPPicClick
{
    [self.view endEditing:YES];
    PicSelectView *picSelectView = [[PicSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    picSelectView.tag = 901;
    picSelectView.delegate = self;
    picSelectView.maxCount = 4-self.uploadBPArray.count;
    [self.tabBarController.view addSubview:picSelectView];
}
-(void)picSelect:(PicSelectView *)picSelectView_temp Camera:(NSString *)filePath Album:(NSMutableArray *)array Flag:(int)flag
{
    
    PicSelectView *picSelectView1 = (PicSelectView *)[self.tabBarController.view viewWithTag:900];
    PicSelectView *picSelectView2 = (PicSelectView *)[self.tabBarController.view viewWithTag:901];
    
    if (picSelectView_temp == picSelectView1) {
        if (flag == 1) {
            [self.uploadPicArray addObject:filePath];
            [self refreshSecViewUI];
        }
        else if (flag == 2)
        {
            [self.uploadPicArray addObjectsFromArray:array];
            [self refreshSecViewUI];
        }

    }
    else
    {
        if (flag == 1) {
            [self.uploadBPArray addObject:filePath];
            [self refreshThirdViewUI];
        }
        else if (flag == 2)
        {
            [self.uploadBPArray addObjectsFromArray:array];
            [self refreshThirdViewUI];
        }

    }
    [picSelectView1 removeFromSuperview];
    [picSelectView2 removeFromSuperview];
}
-(void)refreshSecViewUI
{
    for (UIView *view in secView.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<self.uploadPicArray.count+1; i++) {
        if (i<self.uploadPicArray.count) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, 10, 60, 60) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.uploadPicArray[i]];
            [tempImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress1:)]];
            tempImageView.tag = 600+i;
            [secView addSubview:tempImageView];
        }
        else if(i != 4)
        {
            UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20+i*73, 10, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addPicClick) target:self];
            [secView addSubview:addPic];
        }
    }
}
-(void)refreshThirdViewUI
{
    for (UIView *view in thirdView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]||[view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<self.uploadBPArray.count+1; i++) {
        if (i<self.uploadBPArray.count) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, 50, 60, 60) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.uploadBPArray[i]];
            [tempImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress2:)]];
            tempImageView.tag = 700+i;
            [thirdView addSubview:tempImageView];
        }
        else if(i != 4)
        {
            UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20+i*73, 50, 60, 60) bgImageName:nil imageName:@"n1@2x" title:nil selector:@selector(addBPPicClick) target:self];
            [thirdView addSubview:addPic];
        }
    }
}
-(void)longPress1:(UIGestureRecognizer *)sender
{
    deletePicNum = (int)sender.view.tag-600;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除改图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 550;
        [alert show];
    }
}
-(void)longPress2:(UIGestureRecognizer *)sender
{
    deleteBPPicNum = (int)sender.view.tag-700;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除改图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 551;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 550) {
        if (buttonIndex == 1) {
            [self.uploadPicArray removeObjectAtIndex:deletePicNum];
            [self refreshSecViewUI];
        }
 
    }
    else if (alertView.tag == 551)
    {
        if (buttonIndex == 1) {
            [self.uploadBPArray removeObjectAtIndex:deleteBPPicNum];
            [self refreshThirdViewUI];
        }
    }
}
#pragma mark    选择代理实现

-(void)firstViewClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    int index = (int)sender.tag - 100;
    if (index==0) {
        TTTSelectView *tttSelectView = [[TTTSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        tttSelectView.delegate  = self;
        tttSelectView.tag = 200;
        [tttSelectView StartGetData:9];
        [self.tabBarController.view addSubview:tttSelectView];
    }
    else if (index ==1)
    {
        ProjectStateView *projectStateView = [[ProjectStateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        projectStateView.tag = 201;
        projectStateView.delegate = self;
        [projectStateView loadData];
        [self.tabBarController.view addSubview:projectStateView];
    }
    else if (index == 2)
    {
        PlaceSelectView *placeSelectView = [[PlaceSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        placeSelectView.delegate = self;
        placeSelectView.tag = 202;
        [self.tabBarController.view addSubview:placeSelectView];
    }
}
//-(void)selectProType:(NSString *)projectType ID:(NSString *)id
//{
//    proTypeName = projectType;
//    proTypeID = id;
//    proType.text = proTypeName;
//    proType.textColor = [UIColor blackColor];
//}
-(void)TTTSelect:(TTTSelectView *)typeSelectView1 Dic:(NSDictionary *)dic Flag:(int)flag
{
    [self.view endEditing:YES];
    if (flag == 1) {
        proTypeName= [dic objectForKey:@"subtypeName"];
        proTypeID = [dic objectForKey:@"subtypeID"];
        proType.text = proTypeName;
        proType.textColor = [UIColor blackColor];
    }
    TTTSelectView *tttSelectView = (TTTSelectView *)[self.tabBarController.view viewWithTag:200];
    [tttSelectView removeFromSuperview];
}
-(void)selectProState:(NSString *)projectState ID:(NSString *)id
{
    proStateID = id;
    proStateName =projectState;
    proState.text = proStateName;
    proState.textColor = [UIColor blackColor];
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
    PlaceSelectView *placeSelectView = (PlaceSelectView *)[self.tabBarController.view viewWithTag:202];
    [placeSelectView removeFromSuperview];
}

-(void)commitClick
{
    [self.view endEditing:YES];
    if ([topic.text isEqualToString:@""]) {
        [self showMsg:@"主题不能为空"];
        return;
    }
    else if ([workPlace.text isEqualToString:@"工作地"])
    {
        [self showMsg:@"所在地区不能为空"];
        return;
    }
    else if ([proType.text isEqualToString:@"项目类型"])
    {
        [self showMsg:@"项目类型不能为空"];
        return;
    }
    else if ([proState.text isEqualToString:@"项目阶段"])
    {
        [self showMsg:@"项目阶段不能为空"];
        return;
    }
    else if ([raiseStateLabel.text isEqualToString:@"融资阶段"])
    {
        [self showMsg:@"融资阶段不能为空"];
        return;
    }
    else if ([raiseStateLabel.text isEqualToString:@""])
    {
        [self showMsg:@"融资规模不能为空"];
        return;
    }
    else if ([outPercent.text isEqualToString:@""])
    {
        [self showMsg:@"出让股份比例不能为空"];
        return;
    }
    else if(![MyControll checkGeShi:outPercent.text Regex:@"^(-?\\d+)(\\.\\d+)?$"])
    {
        [self showMsg:@"出让股份比例格式不对"];
        return;
    }
    else if ([MyControll checkGeShi:outPercent.text Regex:@"^(-?\\d+)(\\.\\d+)?$"])
    {
        float num = [outPercent.text floatValue];
        if (num<0.00||num>100.00) {
            [self showMsg:@"比例不能超过100或者小于0"];
            return;
        }
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:topic.text forKey:@"name"];
    [dic setObject:proID forKey:@"pro"];
    [dic setObject:cityID forKey:@"city"];
    [dic setObject:detailPlace.text forKey:@"address"];
    [dic setObject:proTypeID forKey:@"subtype"];
    [dic setObject:proStateID forKey:@"paytype"];
    [dic setObject:ifCanSee forKey:@"imageflag"];
    [dic setObject:raiseStateName forKey:@"rongtype"];
    [dic setObject:raiseGuimo.text forKey:@"lmoney"];
    [dic setObject:outPercent.text forKey:@"hmoney"];
    [dic setObject:partner.text forKey:@"contact"];
    [dic setObject:zhiweiName forKey:@"post"];
    NSString *urlstr = [NSString stringWithFormat:@"%@careatenote5",SERVER_URL];
    
    self.mDownManager= [[ASIDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    if (self.uploadPicArray.count==0&&self.uploadBPArray.count==0) {
        [ _mDownManager PostHttpRequest:urlstr :dic files:nil];
    }
    else
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        if (self.uploadPicArray.count>0) {
            for (int i = 0; i<self.uploadPicArray.count; i++) {
                [dict setObject:self.uploadPicArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
            }
        }
        if (self.uploadBPArray.count>0) {
            
            for (int i = 0; i<self.uploadBPArray.count; i++) {
                [dict setObject:self.uploadBPArray[i] forKey:[NSString stringWithFormat:@"bpfile[%d]",i]];
            }
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
            [self showMsg:@"影视融资发布成功"];
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
