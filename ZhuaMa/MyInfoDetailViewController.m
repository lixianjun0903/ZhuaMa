//
//  MyInfoDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MyInfoDetailViewController.h"
#import "PhotosViewController.h"
#import "ChoseHYViewController.h"
#import "ASIDownManager.h"
#import "WorkInfoViewController.h"
#import "PickDateView.h"
#import "TagsViewController.h"
#import "EduInfoViewController.h"
#import "SpecialtyViewController.h"
#import "PhotoSelectManager.h"
@interface MyInfoDetailViewController ()<UIScrollViewDelegate,ChoseHYDeleagte,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,PickDateDelegate,ChoseSpecialtyDeleagte,photoSelectManagerDelegate>
{
    UIScrollView *mainSC;
    UIView *firstView;
    
    
    UIButton *headView;
    UILabel *nameLabel;
    UILabel *sexLabel;
    UILabel *birthdayLabel;
    UILabel *birthplaceLabel;
    UILabel *homeLabel;
    UILabel *qianmingLabel;
    UILabel *hangyeLabel;
    UILabel *zuopinLabel;
    UILabel *zhiweiLabel;
    UILabel *heightLabel;
    UILabel *weightLabel;
    UILabel *bloodLabel;
    UILabel *xingzuoLabel;
    UILabel *biaoqianLabel;
    UILabel *jingliLabel;
    UILabel *eduJilingLabel;
    
    UILabel *phoneLabel;
    UILabel *emialLabel;
    UILabel *weichatLabel;
    
    UILabel *hobbyLabel;
    UILabel *schoolLabel;
    
    UIView *shadowView;
    
    
    UITextView *biaoqianTX;
    NSString *pickDate;
    UIImage *image;
    NSString *fileway;
    
    BOOL headViewIsPick;
    BOOL headViewIsChanged;
    PhotoSelectManager  *mPhotoManager;
}
@property(nonatomic,strong)ASIDownManager *mDownManager;
@property(nonatomic,strong)NSMutableDictionary *changeDic;
@end

@implementation MyInfoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)GoBack
{
    if ([self.changeDic allKeys].count != 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你已经修改了个人信息,确定离开？" delegate:self cancelButtonTitle:@"离开" otherButtonTitles:@"留在本页", nil];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    headViewIsChanged = NO;
    self.changeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 100, 35) title:@"个人信息" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate = self;
    mainSC.contentSize = CGSizeMake(WIDTH, 1060+64 + 70);
    [self.view addSubview:mainSC];
    
    firstView = [MyControll createToolView3WithFrame:CGRectMake(0, 10, WIDTH, 18*40) withColor:[UIColor whiteColor] withNameArray:@[@"头像",@"个人相册",@"真实姓名",@"性别",@"出生日期",@"所在地",@"家乡",@"个人签名",@"行业",@"作品",@"职位",@"身高",@"体重",@"血型",@"星座",@"个人标签",@"工作经历",@"教育经历"]];
    [mainSC addSubview:firstView];

    headView = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 60, 15, 50, 50) bgImageName:nil imageName:nil title:nil selector:@selector(changeHeadView) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 5;
    [firstView addSubview:headView];
    
    UILabel *xiangceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 80, 170, 40) title:@">" font:15];
    xiangceLabel.textAlignment = NSTextAlignmentRight;
    xiangceLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:xiangceLabel];
    
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 120, 170, 40) title:self.infoDic[@"name"] font:15];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:nameLabel];
    sexLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 160, 170, 40) title:nil font:15];
    sexLabel.textAlignment = NSTextAlignmentRight;
    sexLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:sexLabel];
    birthdayLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 200, 170, 40) title:self.infoDic[@"birthday"] font:15];
    birthdayLabel.textAlignment = NSTextAlignmentRight;
    birthdayLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:birthdayLabel];
    birthplaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 240, 170, 40) title:self.infoDic[@"city"] font:15];
    birthplaceLabel.textAlignment = NSTextAlignmentRight;
    birthplaceLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:birthplaceLabel];
    homeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 280, 170, 40) title:self.infoDic[@"home"] font:15];
    homeLabel.textAlignment = NSTextAlignmentRight;
    homeLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:homeLabel];
    qianmingLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 320, 170, 40) title:self.infoDic[@"sign"] font:15];
    qianmingLabel.textAlignment = NSTextAlignmentRight;
    qianmingLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:qianmingLabel];
    hangyeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 360, 170, 40) title:self.infoDic[@"type"] font:15];
    hangyeLabel.textAlignment = NSTextAlignmentRight;
    hangyeLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:hangyeLabel];
    zuopinLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 400, 170, 40) title:self.infoDic[@"pin"] font:15];
    zuopinLabel.textAlignment = NSTextAlignmentRight;
    zuopinLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:zuopinLabel];
    zhiweiLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 440, 170, 40) title:self.infoDic[@"post"] font:15];
    zhiweiLabel.textAlignment = NSTextAlignmentRight;
    zhiweiLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:zhiweiLabel];
    heightLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 480, 170, 40) title:self.infoDic[@"height"] font:15];
    heightLabel.textAlignment = NSTextAlignmentRight;
    heightLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:heightLabel];
    
    weightLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 520, 170, 40) title:self.infoDic[@"weight"] font:15];
    weightLabel.textAlignment = NSTextAlignmentRight;
    weightLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:weightLabel];
    bloodLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 560, 170, 40) title:self.infoDic[@"xuex"] font:15];
    bloodLabel.textAlignment = NSTextAlignmentRight;
    bloodLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:bloodLabel];
    xingzuoLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 600, 170, 40) title:self.infoDic[@"constellation"] font:15];
    xingzuoLabel.textAlignment = NSTextAlignmentRight;
    xingzuoLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:xingzuoLabel];
    biaoqianLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 640, 170, 40) title:@">" font:15];
    biaoqianLabel.textAlignment = NSTextAlignmentRight;
    biaoqianLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:biaoqianLabel];
    jingliLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 680, 170, 40) title:@">" font:15];
    jingliLabel.textAlignment = NSTextAlignmentRight;
    jingliLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:jingliLabel];

    eduJilingLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 680, 170, 40) title:@">" font:15];
    eduJilingLabel.textAlignment = NSTextAlignmentRight;
    eduJilingLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:eduJilingLabel];

    UILabel *contactWay = [MyControll createLabelWithFrame:CGRectMake(20, 780, 240, 30) title:@"联系方式" font:15];
    [mainSC addSubview:contactWay];
    
    UIView *secView = [MyControll createToolView2WithFrame:CGRectMake(0, 820, WIDTH, 120) withColor:[UIColor whiteColor] withNameArray:@[@"手机",@"邮箱",@"微信"]];
    [mainSC addSubview:secView];
    
    phoneLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 0, 170, 40) title:self.infoDic[@"mobile"] font:15];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.textColor = [UIColor lightGrayColor];
    [secView addSubview:phoneLabel];
    
    emialLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 40, 170, 40) title:self.infoDic[@"email"] font:15];
    emialLabel.textColor = [UIColor lightGrayColor];
    emialLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:emialLabel];
    
    weichatLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 80, 170, 40) title:self.infoDic[@"wei"] font:15];
    weichatLabel.textColor = [UIColor lightGrayColor];
    weichatLabel.textAlignment = NSTextAlignmentRight;
    [secView addSubview:weichatLabel];
    
    
    
    UIView *thirdView = [MyControll createToolView2WithFrame:CGRectMake(0, 960, WIDTH, 80) withColor:[UIColor whiteColor] withNameArray:@[@"特长技能",@"学校"]];
    [mainSC addSubview:thirdView];
    
    hobbyLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 0, 170, 40) title:@">" font:15];
    hobbyLabel.textColor = [UIColor lightGrayColor];
    hobbyLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:hobbyLabel];
    
    schoolLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 180, 40, 170, 40) title:self.infoDic[@"school"] font:15];
    schoolLabel.textColor = [UIColor lightGrayColor];
    schoolLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:schoolLabel];
    
    UIButton *tijiao = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 1070, 260, 40) bgImageName:nil imageName:@"wanc" title:nil selector:@selector(finishClick) target:self];
    [mainSC addSubview:tijiao];
    
    
    for (int i = 0; i<11; i++) {
        UIImageView *star;
        if (i == 0) {
            star  = [MyControll createImageViewWithFrame:CGRectMake(8,0, 5, 80) imageName:@"1@2x(6)"];
        }
        else if (i<=3&&i>=2)
        {
            star = [MyControll createImageViewWithFrame:CGRectMake(8, (i-2)*40+120, 5, 40) imageName:@"1@2x(6)"];
        }
        else if(i>=5&&i<=10)
        {
            star = [MyControll createImageViewWithFrame:CGRectMake(8, (i-5)*40+240, 5, 40) imageName:@"1@2x(6)"];
        }
        star.contentMode = UIViewContentModeScaleAspectFit;
        [firstView addSubview:star];
    }
    
    
    for (int i = 0; i<17; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-180, 80 + i*40,180 , 40) bgImageName:nil imageName:nil title:nil selector:@selector(btnsClick:) target:self];
        [firstView addSubview:btn];
        if (i != 13) {
            btn.tag = 100+i;
        }
        
    }
    for (int i=0; i<3; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-180,i*40,180 , 40) bgImageName:nil imageName:nil title:nil selector:@selector(btnsClick:) target:self];
        btn.tag = 117+i;
        [secView addSubview:btn];
    }
    for (int i=0; i<2; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-180,i*40,180 , 40) bgImageName:nil imageName:nil title:nil selector:@selector(btnsClick:) target:self];
        btn.tag = 120+i;
        [thirdView addSubview:btn];
    }
    shadowView = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64 + 49)];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    shadowView.tag = 700;
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.hidden = YES;
    [self.tabBarController.view addSubview:shadowView];
    [self refreshUI];
}
-(void)tap:(UIGestureRecognizer*)sender
{
    shadowView.hidden = YES;
    UIView * bgView = [self.tabBarController.view viewWithTag:998];
    for (UIView *view in bgView.subviews) {
        [view removeFromSuperview];
    }
    [bgView removeFromSuperview];
}
-(void)refreshUI
{
    if ([self.infoDic[@"face"] isEqualToString:@""]) {
        [headView setImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
        headViewIsPick = NO;
    }
    else
    {
        [headView sd_setBackgroundImageWithURL:[NSURL URLWithString:self.infoDic[@"face"]] forState:UIControlStateNormal];
        headViewIsPick  = YES;
    }
    if ([self.infoDic[@"sex"] isEqualToString:@"0"]) {
        sexLabel.text = @"男";
    }
    else
    {
        sexLabel.text = @"女";
    }
    if ([self.infoDic[@"birthday"] isEqualToString:@""]) {
        birthdayLabel.text = @">";

    }
    else
    {
       birthdayLabel.text = self.infoDic[@"birthday"];
    }
    if ([self.infoDic[@"city"] isEqualToString:@""]) {
        birthplaceLabel.text = @">";
    }
    else
    {
        birthplaceLabel.text = self.infoDic[@"city"];
    }
    if ([self.infoDic[@"home"] isEqualToString:@""]) {
        homeLabel.text = @">";
    }
    else{
        homeLabel.text = self.infoDic[@"home"];
    }
    hangyeLabel.text = self.infoDic[@"type"];
    if ([self.infoDic[@"sign"] isEqualToString:@""]) {
        qianmingLabel.text = @">";
    }
    else
    {
        qianmingLabel.text = self.infoDic[@"sign"];
    }
    if ([self.infoDic[@"pin"] isEqualToString:@""]) {
        zuopinLabel.text = @">";
    }
    else
    {
        zuopinLabel.text = self.infoDic[@"pin"];
    }
    if ([self.infoDic[@"post"] isEqualToString:@""]) {
        zhiweiLabel.text = @">";
    }
    else{
        zhiweiLabel.text = self.infoDic[@"post"];
    }
    if ([self.infoDic[@"height"] isEqualToString:@""]) {
        heightLabel.text = @">";
    }
    else{
        heightLabel.text = [NSString stringWithFormat:@"%@cm",self.infoDic[@"height"]];
    }
    if ([self.infoDic[@"weight"] isEqualToString:@""]) {
        weightLabel.text = @">";
    }
    else{
        weightLabel.text = [NSString stringWithFormat:@"%@kg",self.infoDic[@"weight"]];
    }
    if ([self.infoDic[@"xuex"] isEqualToString:@""]) {
        bloodLabel.text = @">";
    }
    else
    {
        bloodLabel.text = self.infoDic[@"xuex"];
    }
    if ([self.infoDic[@"constellation"] isEqualToString:@""]) {
        xingzuoLabel.text = self.infoDic[@"constellation"];
    }
    else
    {
        xingzuoLabel.text = self.infoDic[@"constellation"];
    }
    if ([self.infoDic[@"mobile"] isEqualToString:@""]) {
        phoneLabel.text = @">";
    }
    else{
        phoneLabel.text = self.infoDic[@"mobile"];
    }
    if ([self.infoDic[@"email"] isEqualToString:@""]) {
        emialLabel.text =@">";
    }
    else{
        emialLabel.text =self.infoDic[@"email"];
    }
    if ([self.infoDic[@"wei"] isEqualToString:@""]) {
        weichatLabel.text =@">";
    }
    else{
        weichatLabel.text =self.infoDic[@"wei"];
    }
    if ([self.infoDic[@"honny"] count]==0) {
        hobbyLabel.text = @">";
    }
    else{
        NSMutableString *hobbyStr;
        for (NSDictionary *dic in (NSArray*)self.infoDic[@"honny"]) {
            [hobbyStr appendString:dic[@"value"]];
        }
        hobbyLabel.text = hobbyStr;
    }
    if ([self.infoDic[@"school"] isEqualToString:@""]) {
        schoolLabel.text = @">";
    }
    else
    {
        schoolLabel.text = self.infoDic[@"school"];
    }
}
-(void)changeHeadView
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册" ,nil];
    sheet.tag = 1235;
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1235) {
        if (buttonIndex == 0 || buttonIndex == 1) {
            mPhotoManager = [[PhotoSelectManager alloc] init];
            mPhotoManager.mRootCtrl = self;
            mPhotoManager.delegate = self;
            mPhotoManager.photoDelegate = self;
            mPhotoManager.mDefaultName = @"headimage.png";
            mPhotoManager.mbEdit = YES;
            mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
            buttonIndex == 0?[mPhotoManager TakePhoto:YES]:[mPhotoManager TakePhoto:NO];
        }else if(buttonIndex == 2){
           
        }

    }
    else if (actionSheet.tag == 1234)
    {
        if (buttonIndex == 0) {
            [self.changeDic setObject:@"A型" forKey:@"xuex"];
            bloodLabel.text = @"A型";
        }
       else if (buttonIndex == 1) {
            [self.changeDic setObject:@"B型" forKey:@"xuex"];
           bloodLabel.text = @"B型";
        }
       else if (buttonIndex == 2) {
            [self.changeDic setObject:@"AB型" forKey:@"xuex"];
           bloodLabel.text = @"AB型";
        }
       else if (buttonIndex == 3) {
            [self.changeDic setObject:@"O型" forKey:@"xuex"];
           bloodLabel.text = @"O型";
        }
    }
}
//选中图片回调
- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    fileway = sender.mLocalPath;
    [headView setImage:[UIImage imageWithContentsOfFile:fileway] forState:UIControlStateNormal];
  
    headViewIsPick = YES;
    headViewIsChanged = YES;
}
//退出相册管理者类回调
- (void)photoSelectManagerAccessFail{
    
}
-(void)btnsClick:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    NSLog(@"%d",index);
    
    NSArray *textArray = @[self.infoDic[@"name"],@"",@"",
                           self.infoDic[@"city"],self.infoDic[@"home"],self.infoDic[@"sign"],@"",self.infoDic[@"pin"],self.infoDic[@"post"],self.infoDic[@"height"],self.infoDic[@"weight"],@"",@"",@"",@"",@"",self.infoDic[@"mobile"],self.infoDic[@"email"],self.infoDic[@"wei"],@"",self.infoDic[@"school"]];
    NSArray *titleArray = @[@"修改姓名",@"",@"",@"修改所在地",@"修改家乡",@"修改个人签名",@"",@"修改作品",@"修改职位",@"修改身高",@"修改体重",@"",@"",@"",@"",@"",@"修改手机号码",@"修改邮箱",@"修改微信号",@"修改爱好",@"修改学校"];
    if (index == 1||index == 4||index == 5||index == 6||index == 8||index==9||index==10||index==11||index==17||index==18||index ==19||index==21) {
        shadowView.hidden = NO;
        UIView * bgView = [MyControll createViewWithFrame:CGRectMake(10, -210, WIDTH - 20, 210)];
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(10, 80, WIDTH - 20, 210);
        }];
        
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.tag = 998;
        [self.tabBarController.view addSubview:bgView];
        
        UILabel *tishiLabel = [MyControll createLabelWithFrame:CGRectMake(20, 20, 100, 20) title:titleArray[index-1] font:14];
        tishiLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
        [bgView addSubview:tishiLabel];
//        biaoqianTX = [MyControll createTextFieldWithFrame:CGRectMake(20, 60, bgView.frame.size.width - 40, 40) text:nil placehold:nil font:14];
        biaoqianTX = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, bgView.frame.size.width - 40, 60)];
        biaoqianTX.text = textArray[index-1];
        biaoqianTX.font = [UIFont systemFontOfSize:14];
        biaoqianTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
        if (index == 10||index==11||index==17) {
            biaoqianTX.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            biaoqianTX.keyboardType = UIKeyboardTypeDefault;
        }
        [biaoqianTX becomeFirstResponder];
        biaoqianTX.layer.borderWidth = 1;
        [bgView addSubview:biaoqianTX];
        
        UIButton *addCancleBtn  = [MyControll createButtonWithFrame:CGRectMake(20, 140, 110, 40) bgImageName:nil imageName:@"quxiao" title:nil selector:@selector(addClick:) target:self];
        addCancleBtn.tag = 599;
        addCancleBtn.clipsToBounds = YES;
        addCancleBtn.layer.cornerRadius = 3;
        [bgView addSubview:addCancleBtn];
        
        UIButton *addConfirmBtn = [MyControll createButtonWithFrame:CGRectMake(bgView.frame.size.width - 130, 140, 110, 40) bgImageName:nil imageName:@"queding" title:nil selector:@selector(addClick:) target:self];
        addConfirmBtn.tag = 600+index;
        addConfirmBtn.layer.cornerRadius = 3;
        addConfirmBtn.clipsToBounds = YES;
        [bgView addSubview:addConfirmBtn];
    }
   else if (index ==0)
   {
       PhotosViewController *vc = [[PhotosViewController alloc]init];
       vc.hidesBottomBarWhenPushed = YES;
       vc.picArray = self.infoDic[@"image"];
       [self.navigationController pushViewController:vc animated:YES];
   }
    else if(index == 2)
    {
        shadowView.hidden = NO;
        UIView * bgView = [MyControll createViewWithFrame:CGRectMake(10, 200, WIDTH - 20, 150)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.tag = 998;
        [self.tabBarController.view addSubview:bgView];
        
        UILabel *tishiLabel = [MyControll createLabelWithFrame:CGRectMake(20, 20, 100, 20) title:@"选择性别" font:14];
        tishiLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
        [bgView addSubview:tishiLabel];
        
        UIButton *nanBtn  = [MyControll createButtonWithFrame:CGRectMake(20, 70, 110, 40) bgImageName:nil imageName:@"nan2" title:nil selector:@selector(addClick:) target:self];
        nanBtn.tag = 622;
        nanBtn.clipsToBounds = YES;
        nanBtn.layer.cornerRadius = 3;
        [bgView addSubview:nanBtn];
        
        UIButton *nvBtn = [MyControll createButtonWithFrame:CGRectMake(bgView.frame.size.width - 130, 70, 110, 40) bgImageName:nil imageName:@"nv2" title:nil selector:@selector(addClick:) target:self];
        nvBtn.tag = 623;
        nvBtn.layer.cornerRadius = 3;
        nvBtn.clipsToBounds = YES;
        [bgView addSubview:nvBtn];
    }
    else if (index == 3)
    {
        PickDateView *pickDateView = [[PickDateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        pickDateView.tag = 1000;
        pickDateView.isShowTitle = NO;
        pickDateView.delegate = self;
        pickDateView.startDate = @"1900-01-01 12:00";
        if (pickDate) {
             pickDateView.showDate = pickDate;
        }
        else{
            if ([self.infoDic[@"birthday"] length]<16) {
                pickDateView.showDate = pickDateView.startDate;
            }
            else{
                 pickDateView.showDate = [NSString stringWithFormat:@"%@ 12:00",self.infoDic[@"birthday"]];
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        pickDateView.stopDate = [formatter stringFromDate:[NSDate date]];
        [pickDateView config];
        [self.tabBarController.view addSubview:pickDateView];
    }
    else if (index == 7)
    {
        ChoseHYViewController *vc = [[ChoseHYViewController alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 12)
    {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择血型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"A型",@"B型",@"AB型",@"O型" ,nil];
        sheet.tag = 1234;
        [sheet showInView:self.view];
    }
    else if(index == 14)
    {
        TagsViewController *vc = [[TagsViewController alloc]init];
        vc.dataArray = self.infoDic[@"tags"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 15)
    {
        WorkInfoViewController *vc = [[WorkInfoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 16)
    {
        EduInfoViewController *vc = [[EduInfoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 20)
    {
        SpecialtyViewController *vc = [[SpecialtyViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)didSelectDate:(NSString *)selectDate PickDateView:(PickDateView *)pickDateView
{
    if (pickDateView.tag == 1000) {
        NSLog(@"%@",selectDate);
        pickDate = selectDate;
        [self.changeDic setObject:[pickDate componentsSeparatedByString:@" "][0] forKey:@"birthday"];
        birthdayLabel.text = [pickDate componentsSeparatedByString:@" "][0];
        
        [self.changeDic setObject:birthdayLabel.text forKey:@"birthday"];
        
        int mon = [[pickDate substringWithRange:NSMakeRange(5, 2)] intValue];
        int day = [[pickDate substringWithRange:NSMakeRange(8, 2)] intValue];
        xingzuoLabel.text = [NSString stringWithFormat:@"%@座",[self getAstroWithMonth:mon day:day]];
        [self.changeDic setObject:xingzuoLabel.text forKey:@"constellation"];
        [self removeView];
    }
}
-(void)removeView
{
    PickDateView *pickDateView = (PickDateView *)[self.tabBarController.view viewWithTag:1000];
    [pickDateView removeFromSuperview];
    pickDateView = nil;
}
-(void)addClick:(UIButton *)sender
{
    if (sender.tag == 599) {
 
    }
    else if (sender.tag == 601)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"姓名不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"name"];
            nameLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 604)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"所在地填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"city"];
            birthplaceLabel.text= biaoqianTX.text;
        }
    }
    else if (sender.tag == 605)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"家乡填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"home"];
            homeLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 606)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"个人签名填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"sign"];
            qianmingLabel.text = biaoqianTX.text;
            qianmingLabel.adjustsFontSizeToFitWidth = YES;
        }
    }
    else if (sender.tag == 608)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"作品填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"pin"];
            zuopinLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 609)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"职位填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"post"];
            zhiweiLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 610)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"身高填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"height"];
            heightLabel.text = [NSString stringWithFormat:@"%@cm",biaoqianTX.text];
        }
    }
    else if (sender.tag == 611)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"体重填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"weight"];
            weightLabel.text = [NSString stringWithFormat:@"%@kg",biaoqianTX.text];
        }
    }
    else if (sender.tag == 615)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"经历填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"text"];
//            jingliLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 617)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"手机号码填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"mobile"];
            phoneLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 618)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"邮箱填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"email"];
            emialLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 619)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"微信号填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"wei"];
            weichatLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 620)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"爱好填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"honny"];
            hobbyLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 621)
    {
        if (biaoqianTX.text.length==0) {
            [self showMsg:@"学校填写不能为空"];
            return;
        }
        else
        {
            [self.changeDic setObject:biaoqianTX.text forKey:@"school"];
            schoolLabel.text = biaoqianTX.text;
        }
    }
    else if (sender.tag == 622)
    {
    [self.changeDic setObject:@"0" forKey:@"sex"];
        sexLabel.text = @"男";
    
    }
    else if (sender.tag == 623)
    {
        [self.changeDic setObject:@"1" forKey:@"sex"];
        sexLabel.text = @"女";

    }
    else if (sender.tag == 624)
    {
       
    }
    UIView * bgView = [self.tabBarController.view viewWithTag:998];
    
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake(10, -210, WIDTH - 20, 210);
        [biaoqianTX resignFirstResponder];
    } completion:^(BOOL finished) {
        if (finished) {
            shadowView.hidden = YES;
            for (UIView *view in bgView.subviews) {
                [view removeFromSuperview];
            }
            [bgView removeFromSuperview];
        }
    }];

}
-(void)changeHY:(NSArray *)array
{
    [self.changeDic setObject:array forKey:@"type"];
    hangyeLabel.text = [NSString stringWithFormat:@"已选择%d项",(int)array.count];
}
-(void)changeSpecialty:(NSArray *)array
{
    [self.changeDic setObject:array forKey:@"honny"];
    hobbyLabel.text = [NSString stringWithFormat:@"已选择%d项",(int)array.count];
}
-(void)finishClick
{
    if (!headViewIsPick) {
        [self showMsg:@"请上传头像"];
        return;
    }
    else if ([birthplaceLabel.text isEqualToString:@">"])
    {
        [self showMsg:@"请填写所在地"];
        return;
    }
    else if ([homeLabel.text isEqualToString:@">"])
    {
        [self showMsg:@"请填写家乡"];
        return;
    }
    else if ([qianmingLabel.text isEqualToString:@">"])
    {
        [self showMsg:@"请输入个人签名"];
        return;
    }
    else if ([zuopinLabel.text isEqualToString:@">"])
    {
        [self showMsg:@"请输入作品"];
        return;
    }
    else if ([zhiweiLabel.text isEqualToString:@">"])
    {
        [self showMsg:@"请输入职位"];
        return;
    }
    [self loadData];
}
#pragma mark  获取数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *str = [self.changeDic JSONRepresentation];
    NSString *urlstr = [NSString stringWithFormat:@"%@updateuserinfo2",SERVER_URL];
    self.mDownManager= [[ASIDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:str forKey:@"content"];
    [_mDownManager PostHttpRequest:urlstr :dic :fileway :@"video"];
    
}
-(void)OnLoadFinish:(ASIDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"个人资料修改成功"];
            [self performSelector:@selector(GoBack1) withObject:nil afterDelay:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
        }
        else
        {
            [self showMsg:[NSString stringWithFormat:@"%@",dict[@"message"]]];
        }
    }
}
-(void)GoBack1
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)OnLoadFail:(ASIDownManager *)sender {
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
-(NSString *)getAstroWithMonth:(int)m day:(int)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
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
