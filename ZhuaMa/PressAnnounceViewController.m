//
//  PressAnnounceViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/26.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "PressAnnounceViewController.h"
#import "ASIDownManager.h"
#import "CityView.h"
#import "CityDetailView.h"
#import "TypeView.h"
@interface PressAnnounceViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,CitySelectDelegate,CityDetailSelectDelegate,TypeSelectDelegate>
{
    UIScrollView *mainSC;
    UIView *firstView;
    UIView *secView;
    
    
    UITextField *tongaoName;
    UILabel *typelabel;
    UITextField *zuidiXinjin;
    UITextField *zuigaoXinjin;
    int sex;
    UITextField *renshu;
    UITextField *ageTx;
    UITextField *shengao;
    UITextField *weightTx;
    UILabel *sheng;
    UILabel *shi;
    UITextView *textView;
    UILabel *timeLabel;
    
    UIImage *image;
    UIButton *addBtn;
    int picNum;
    
    NSString *cityName;
    NSString *cityID;
    NSString *shengID;
    
    UIView *bgView;
    NSString *pickDate;
    
    NSString *type;
}
@property(nonatomic,strong)ASIDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *pickArray;
@end

@implementation PressAnnounceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sex = 0;//性别选择
    picNum = 999;//用来判断图片是否选择来删除
    self.pickArray =[NSMutableArray arrayWithCapacity:3];
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"发布通告" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
#pragma mark     主UI
-(void)makeUI
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate = self;
    mainSC.contentSize = CGSizeMake(WIDTH, 810 + 64);
    [self.view addSubview:mainSC];
    
    firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 10, WIDTH, 550) withColor:[UIColor whiteColor] withNameArray:@[@"通告名称",@"招募类型",@"薪       金",@"性       别",@"人       数",@"身       高",@"拍摄地点",@"集合地点",@"集合时间",@"联  系  人",@"电       话"]];
    [mainSC addSubview:firstView];
    
    tongaoName = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/5 + 50, 5, WIDTH/5 *4 - 50 - 10, 40)];
    tongaoName.placeholder = @"请输入通告名称";
    tongaoName.font = [UIFont systemFontOfSize:15];
    tongaoName.tag = 100;
    [firstView addSubview:tongaoName];
    
    typelabel = [MyControll createLabelWithFrame:CGRectMake(self.view.frame.size.width/5 + 50, 55, WIDTH/5 *4 - 50 - 10, 40) title:nil font:15];
    typelabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:typelabel];
    UIImageView *right = [MyControll createImageViewWithFrame:CGRectMake(WIDTH - 25, 50, 20, 50) imageName:@"37"];
    right.contentMode = UIViewContentModeCenter;
    [firstView addSubview:right];
    UIButton *typeBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+50, 50, WIDTH/4*4-50, 50) bgImageName:nil imageName:nil title:nil selector:@selector(typeBtnClick) target:self];
    [firstView addSubview:typeBtn];
    
    zuidiXinjin = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50, 110, 80, 30) text:nil placehold:nil font:15];
    zuidiXinjin.tag = 101;
    zuidiXinjin.keyboardType = UIKeyboardTypeNumberPad;
    zuidiXinjin.layer.borderWidth = 0.5;
    zuidiXinjin.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:zuidiXinjin];
    
    UILabel *henghang =[MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 80 +5, 100, 5, 50) title:@"-" font:15];
    [firstView addSubview:henghang];
    
    zuigaoXinjin = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50 + 80 +15, 110, 80, 30) text:nil placehold:nil font:15];
    zuigaoXinjin.tag = 102;
    zuigaoXinjin.keyboardType =UIKeyboardTypeNumberPad;
    zuigaoXinjin.layer.borderWidth = 0.5;
    zuigaoXinjin.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:zuigaoXinjin];
    
    NSArray *sexType = @[@"不限",@"男",@"女"];
    for (int i= 0; i<3; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+50 + 80*i, 150, 20, 50) bgImageName:nil imageName:@"57" title:nil selector:@selector(btnClick:) target:self];
        btn.tag = 10+i;
        if (btn.tag == 10) {
            btn.selected = YES;
        }
        [btn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
        [firstView addSubview:btn];
        
        UILabel *sexLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 25 + 80*i, 155, 30, 40) title:sexType[i] font:15];
        [firstView addSubview:sexLabel];
    }
    renshu = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50, 210, 50, 30) text:nil placehold:nil font:15];
    renshu.tag = 103;
    renshu.keyboardType = UIKeyboardTypeNumberPad;
    renshu.layer.borderWidth = 0.5;
    renshu.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:renshu];
    
    UILabel *ageLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 55, 205, 40, 40) title:@"年龄" font:15];
    ageLabel.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:ageLabel];
    ageTx = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50 + 55+40+5, 210, 50, 30) text:nil placehold:nil font:15];
    ageTx.tag = 104;
    ageTx.layer.borderWidth = 0.5;
    ageTx.keyboardType = UIKeyboardTypeNumberPad;
    ageTx.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:ageTx];
    UILabel *other1 = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 55+40+5 + 50 + 5, 205, 50, 40) title:@"岁左右" font:14];
    other1.textColor = [UIColor lightGrayColor];
    [firstView addSubview:other1];

    shengao = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50, 260, 50, 30) text:nil placehold:nil font:15];
    shengao.tag = 105;
    shengao.layer.borderWidth = 0.5;
    shengao.keyboardType = UIKeyboardTypeNumberPad;
    shengao.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:shengao];
    
    UILabel *weightLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 55, 255, 40, 40) title:@"体重" font:15];
    weightLabel.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:weightLabel];
    weightTx = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50 + 55+40+5, 260, 50, 30) text:nil placehold:nil font:15];
    weightTx.tag = 106;
    weightTx.layer.borderWidth = 0.5;
    weightTx.keyboardType = UIKeyboardTypeNumberPad;
    weightTx.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:weightTx];
    UILabel *other2 = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 55+40+5 + 50 + 5, 255, 50, 40) title:@"kg左右" font:14];
    other2.textColor = [UIColor lightGrayColor];
    [firstView addSubview:other2];
    
//    sheng = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50, 310, 80, 30) text:nil placehold:@"省" font:15];
    sheng = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50, 310, 80, 30) title:@"省" font:15];
    sheng.tag = 107;
    sheng.layer.borderWidth = 0.5;
    sheng.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:sheng];
    
    UIButton *shengBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+50, 310, 80, 30) bgImageName:nil imageName:nil title:nil selector:@selector(shengshiClick:) target:self];
    shengBtn.tag = 9999;
    [firstView addSubview:shengBtn];
    
    UILabel *henghang1 =[MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50 + 80 +5, 300, 5, 50) title:@"-" font:15];
    [firstView addSubview:henghang1];
    
//    shi = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+50 + 80 +15, 310, 80, 30) text:nil placehold:@"市" font:15];
    shi = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50+80+15, 310, 80, 30) title:@"市" font:15];
    shi.tag = 108;
    shi.layer.borderWidth = 0.5;
    shi.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [firstView addSubview:shi];
    
    UIButton *shiBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+50+80+15, 310, 80, 30) bgImageName:nil imageName:nil title:nil selector:@selector(shengshiClick:) target:self];
    shiBtn.tag = 9998;
//    [firstView addSubview:shiBtn];
    
    NSArray *txArray = @[@"请输入详细地址",@"请输入集合时间",@"请输入联系人姓名",@"请输入联系人电话"];
    for (int i = 0; i<4; i++) {
        if (i!=1) {
            UITextField *tx = [MyControll createTextFieldWithFrame:CGRectMake(self.view.frame.size.width/5 + 50, 355 + 50*i, WIDTH/5 *4 - 50 - 10, 40) text:nil placehold:txArray[i] font:15];
            tx.tag = 109+i;
            if (i==3) {
                tx.keyboardType =UIKeyboardTypeNumberPad;
            }
            [firstView addSubview:tx];
        }
       else if (i == 1) {
           timeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+50, 355+50*i, WIDTH/5*4-50-10, 40) title:txArray[i] font:15];
           timeLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
           [firstView addSubview:timeLabel];
           UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+50, 355+50*i, WIDTH/5*4-50-10, 40) bgImageName:nil imageName:nil title:nil selector:@selector(choseTime) target:self];
           [firstView addSubview:btn];
        }
    }
    
    secView = [MyControll createToolView2WithFrame:CGRectMake(0, 570, WIDTH, 50) withColor:[UIColor whiteColor] withNameArray:@[@"添加照片"]];
    [mainSC addSubview:secView];
    
    addBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/5+50, 10, 30, 30) bgImageName:nil imageName:@"88" title:nil selector:@selector(add) target:self];
    [secView addSubview:addBtn];
    
    
    UILabel *beizhu = [MyControll createLabelWithFrame:CGRectMake(15, 620, 60, 50) title:@"备注" font:15];
    [mainSC addSubview:beizhu];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 680, WIDTH, 70)];
    textView.tag = 1000;
    textView.text = @"";
    [mainSC addSubview:textView];
    
    UIButton *fabuBtn = [MyControll createButtonWithFrame:CGRectMake(15, 760, WIDTH - 30, 40) bgImageName:nil imageName:@"58" title:nil selector:@selector(fabu) target:self];
    [mainSC addSubview:fabuBtn];
    
}
-(void)choseTime
{
    [self hideKeyBoard];
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64 + 49)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 800;
    [self.tabBarController.view addSubview:view];

    bgView = [MyControll createViewWithFrame:CGRectMake(0, view.frame.size.height +49, WIDTH, 256+30)];
    [view addSubview:bgView];
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake(0, view.frame.size.height - 256-30, WIDTH, 256+30);
    }];
    UIDatePicker *_datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 256 )];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //日期模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    //定义最小日期
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *maxDate = [formatter_minDate dateFromString:@"2025-01-01 12:00"];
    
    NSDate *minDate = [NSDate date];
    
    [_datePicker setMinimumDate:minDate];
    [_datePicker setMaximumDate:maxDate];
    if (!pickDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        pickDate = [formatter stringFromDate:[NSDate date]];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [_datePicker setDate:[formatter dateFromString:pickDate]];
    [_datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:_datePicker];
    
    UIView *bgview = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    bgview.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:bgview];
    UIButton *cancelBtn = [MyControll createButtonWithFrame:CGRectMake(20, 5, 40, 20) bgImageName:nil imageName:nil title:@"取消" selector:@selector(dateClick:) target:self];
    cancelBtn.tag = 432;
    [bgview addSubview:cancelBtn];
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 60, 5, 40, 20) bgImageName:nil imageName:nil title:@"确定" selector:@selector(dateClick:) target:self];
    confirmBtn.tag = 431;
    [bgview addSubview:confirmBtn];
}
-(void)dateClick:(UIButton *)sender
{
    [self hideKeyBoard];
    UIView *view = [self.tabBarController.view viewWithTag:800];
    if (sender.tag == 431) {
        timeLabel.textColor = [UIColor darkTextColor];
        timeLabel.text = pickDate;
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(0, view.frame.size.height + 49, WIDTH, 256+30);
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
            bgView = nil;
        }];
        UIView *view = [self.tabBarController.view viewWithTag:800];
        for (UIView *v in view.subviews)
        {
            [v removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    else if(sender.tag == 432)
    {
//        timeLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(0, view.frame.size.height + 49, WIDTH, 256+30);
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
            bgView = nil;
        }];
        UIView *view = [self.tabBarController.view viewWithTag:800];
        for (UIView *v in view.subviews)
        {
            [v removeFromSuperview];
        }
        [view removeFromSuperview];
    }
}
-(void)dataValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    pickDate = [formatter stringFromDate:date_one];
}
-(void)shengshiClick:(UIButton *)sender
{
    [self hideKeyBoard];
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 700;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewRemove:)]];
    [self.tabBarController.view addSubview:view];
    if (sender.tag == 9999) {
        CityView *cityView = [[CityView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, HEIGHT - 90-64)];
        cityView.tag = 2000;
        cityView.delegate = self;
        [cityView loadData];
        [self.tabBarController.view addSubview:cityView];
    }
}
#pragma mark  选择城市
-(void)selectCity:(NSString *)city ID:(NSString *)id
{
    cityName = city;
    shengID = id;
    
    if([cityName isEqualToString:@"#全部省份"])
    {
        UIView *view = [self.tabBarController.view viewWithTag:700];
        CityView *cityView = (CityView *)[self.tabBarController.view viewWithTag:2000];
        for (UIView *v in cityView.subviews)
        {
            [v removeFromSuperview];
        }
        [cityView removeFromSuperview];
        
        for (UIView *v in view.subviews)
        {
            [v removeFromSuperview];
        }
        [view removeFromSuperview];
        sheng.text = @"全部省份";
        shi.text= @"全部城市";
        cityID = @"0";
        return;
    }
    shi.text = @"";
    cityID = shengID;
    CityView *cityView = (CityView *)[self.tabBarController.view viewWithTag:2000];
    for (UIView *v in cityView.subviews)
    {
        [v removeFromSuperview];
    }
    [cityView removeFromSuperview];
    
    CityDetailView *cityDetailView = [[CityDetailView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, HEIGHT - 90-64)];
    cityDetailView.tag = 2001;
    cityDetailView.delegate = self;
    [cityDetailView loadData:id];
    [self.tabBarController.view addSubview:cityDetailView];
    sheng.text = city;
}
-(void)selectCityDetail:(NSString *)city ID:(NSString *)id
{
    cityID = id;
    cityName = city;
    [self viewRemove:nil];
    
    shi.text = city;
}
-(void)btnClick:(UIButton *)sender
{
    for (int i = 0; i<3; i++) {
        UIButton *btn = (UIButton *)[firstView viewWithTag:10+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    sex = (int)sender.tag - 10;
}
-(void)selectType:(NSString *)type1 ID:(NSString *)id
{
    typelabel.text = type1;
    type = id;
    [self viewRemove:nil];
}
-(void)typeBtnClick
{
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 700;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewRemove:)]];
    [self.tabBarController.view addSubview:view];
    TypeView *typeView = [[TypeView alloc]initWithFrame:CGRectMake(0, 90, WIDTH,280)];
    typeView.tag = 2002;
    typeView.delegate = self;
    [typeView loadData:10];
    [self.tabBarController.view addSubview:typeView];
}
-(void)viewRemove:(UITapGestureRecognizer *)sender
{
    UIView *view = [self.tabBarController.view viewWithTag:700];
    
    [view removeFromSuperview ];
    view = nil;
    CityView *city = (CityView *)[self.tabBarController.view viewWithTag:2000];
    [city removeFromSuperview];
    CityDetailView *cityDetailView = (CityDetailView *)[self.tabBarController.view viewWithTag:2001];
    [cityDetailView removeFromSuperview];
    TypeView *typeView = (TypeView *)[self.tabBarController.view viewWithTag:2002];
    [typeView removeFromSuperview];
}
-(void)showPic
{
    
    for (int i= 0; i<self.pickArray.count+1; i++) {
        if (i<self.pickArray.count) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
                UIImage *img = [UIImage imageWithContentsOfFile:self.pickArray[i]];
                UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(WIDTH/5+50+i*40, 10, 30, 30) imageName:nil];
                imageView.tag = 6000+i;
                imageView.image = img;
                [imageView addGestureRecognizer:longPress];
                [secView addSubview:imageView];
        
        }
        else if (i==self.pickArray.count&&i!=1)
        {
            addBtn.frame = CGRectMake(WIDTH/5+50+i*40, 10, 30, 30);
        }
    }
}
-(void)add
{
    [self hideKeyBoard];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机" ,nil];
        [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==2)
    {
        return;
    }
    //判断相机还是相册
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if(buttonIndex == 1)
    {
        //如果选择是相机，需要判断相机是否可以开启
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else
    {
        
    }
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark  获取图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获取照片
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //进行相应记录
    
    int miWidth = 600;
    int  miHeight = 600;
    int iWidth = image.size.width;
    int iHeight = image.size.height;
    

    if (iWidth > iHeight) {
        if (iWidth>miWidth) {
            iWidth = miWidth;
            iHeight = image.size.height*iWidth/image.size.width;
    }
    else
    {
        if (iHeight>miHeight) {
            iHeight = miHeight;
            iWidth = image.size.width*iHeight/image.size.height;
        }
    }
     }
    image = [self scaleToSize:image :CGSizeMake(iWidth, iHeight)];
  
    NSData *data = nil;
    NSString *picType;
    if (UIImagePNGRepresentation(image)) {
        
        data = UIImageJPEGRepresentation(image, 0.85);
        picType = @"jpg";
    }else{
        data = UIImageJPEGRepresentation(image, 0.85);
        picType = @"jpg";
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
        NSDate *date =[NSDate date];
        NSString *str = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]];
    filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,str,picType];
    [data writeToFile:filePath atomically:YES];
        for (int i=0; i<self.pickArray.count; i++) {
            UIImageView *imageView = (UIImageView *)[secView viewWithTag:6000+i];
            [imageView removeFromSuperview];
            imageView = nil;
        }
        [self.pickArray addObject:filePath];
        [self showPic];
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
//图片缩放
- (UIImage *)scaleToSize:(UIImage *)image1 :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image1 drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  --------------------
-(void)longPress:(UIGestureRecognizer *)sender
{
    [self hideKeyBoard];
    if (sender.state == UIGestureRecognizerStateBegan) {
        picNum = (int)sender.view.tag-6000;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你想删除这张图片吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (picNum != 999) {
            for (int i=0; i<self.pickArray.count; i++) {
                UIImageView *imageView = (UIImageView *)[secView viewWithTag:6000+i];
                    [imageView removeFromSuperview];
                    imageView = nil;
            }
            [self.pickArray removeObjectAtIndex:picNum];
            [self showPic];
        }
        
    }
}
-(void)fabu
{
    if ([tongaoName.text length]==0) {
        [self showMsg:@"通告名称不能为空"];
        [tongaoName becomeFirstResponder];
        return;
    }
  else  if ([typelabel.text length]==0) {
//        [self showMsg:@"招募类型没有选择"];
//        return;
    }
  else  if ([zuidiXinjin.text length]==0) {
        [self showMsg:@"最低薪金没有填写"];
        [zuidiXinjin becomeFirstResponder];
        return;
    }
  else  if ([zuigaoXinjin.text length] == 0) {
        [self showMsg:@"最高薪金没有填写"];
        [zuigaoXinjin becomeFirstResponder];
        return;
    }
  else  if ([renshu.text length]==0) {
        [self showMsg:@"人数没有填写"];
        [renshu becomeFirstResponder];
        return;
    }
  else  if ([ageTx.text length]==0) {
        [self showMsg:@"年龄没有填写"];
        [ageTx becomeFirstResponder];
        return;
    }
  else  if ([shengao.text length] == 0) {
        [self showMsg:@"身高没有填写"];
        [shengao becomeFirstResponder];
        return;
    }
  else  if ([weightTx.text length]==0) {
        [self showMsg:@"体重没有填写"];
        [weightTx becomeFirstResponder];
        return;
    }
  else  if ([sheng.text isEqualToString:@"省"]) {
        [self showMsg:@"请选择省份"];
        [sheng becomeFirstResponder];
        return;
    }
   else if ([shi.text isEqualToString:@"市"]) {
        [self showMsg:@"请选择城市"];
        [shi becomeFirstResponder];
        return;
    }
    UITextField *tx1 = (UITextField *)[firstView viewWithTag:109];
//    UITextField *tx2 = (UITextField *)[firstView viewWithTag:110];
    UITextField *tx3 = (UITextField *)[firstView viewWithTag:111];
    UITextField *tx4 = (UITextField *)[firstView viewWithTag:112];
    
   if ([tx1.text length]== 0) {
        [self showMsg:@"请输入详细地址"];
        [tx1 becomeFirstResponder];
        return;
    }
  else  if ([timeLabel.text isEqualToString:@"请输入集合时间"]) {
        [self showMsg:@"请输入集合时间"];
        return;
    }
   else if ([tx3.text length]==0) {
        [self showMsg:@"请输入联系人姓名"];
        [tx3 becomeFirstResponder];
        return;
    }
  else  if ([tx4.text length]==0) {
        [self showMsg:@"请输入联系人电话"];
        [tx4 becomeFirstResponder];
        return;
    }
    [self loadData];
}
-(void)hideKeyBoard
{
    for (int i = 0; i<13; i++) {
        if (i != 110) {
            UITextField *tx = (UITextField *)[firstView viewWithTag:100+i];
            [tx resignFirstResponder];
        }
    }
    UITextView *txview = (UITextView *)[mainSC viewWithTag:1000];
    [txview resignFirstResponder];
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [self hideKeyBoard];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}
#pragma mark  发布通告
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    UITextField *tx1 = (UITextField *)[firstView viewWithTag:109];
    UITextField *tx3 = (UITextField *)[firstView viewWithTag:111];
    UITextField *tx4 = (UITextField *)[firstView viewWithTag:112];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    
     NSString *str1 = [tongaoName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString *str2 = [tx1.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString *str3 = [tx3.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSString *str4 = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@careatenote?uid=%@&token=%@&name=%@&type=%@&lmoney=%@&hmoney=%@&sex=%d&num=%@&age=%@&height=%@&weight=%@&pro=%@&city=%@&address=%@&jtime=%@&contact=%@&mobile=%@&tag=%@&note=%@",SERVER_URL,uid,token,str1,type,zuidiXinjin.text,zuigaoXinjin.text,sex,renshu.text,ageTx.text,shengao.text,weightTx.text,shengID,cityID,str2,pickDate,str3,tx4.text,@"",str4];
    
//    NSString *urlstr = [NSString stringWithFormat:@"%@careatenote",SERVER_URL];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:str1 forKey:@"name"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:zuidiXinjin.text forKey:@"lmoney"];
    [dic setObject:zuigaoXinjin.text forKey:@"hmoney"];
    [dic setObject:[NSString stringWithFormat:@"%d",sex] forKey:@"sex"];
    [dic setObject:renshu.text forKey:@"num"];
    [dic setObject:ageTx.text forKey:@"age"];
    [dic setObject:shengao.text forKey:@"height"];
    [dic setObject:weightTx.text forKey:@"weight"];
    [dic setObject:shengID forKey:@"pro"];
    [dic setObject:cityID forKey:@"city"];
    [dic setObject:str2 forKey:@"address"];
    [dic setObject:pickDate forKey:@"jtime"];
    [dic setObject:str3 forKey:@"contact"];
    [dic setObject:tx4.text forKey:@"mobile"];
    [dic setObject:@"" forKey:@"tag"];
    [dic setObject:str4 forKey:@"note"];
    
    
    self.mDownManager= [[ASIDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    if (self.pickArray.count != 0) {
        [_mDownManager PostHttpRequest:urlstr :nil :self.pickArray[0] :@"file"];
    }
    else
    {
        [_mDownManager PostHttpRequest:urlstr :nil :nil :nil];
    }

}
-(void)OnLoadFinish:(ASIDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
   
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"发布成功"];
            [self performSelector:@selector(GoBack1) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:@"发布失败"];
        }
    }
}
-(void)GoBack1
{
    [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"fabuSuccess" object:nil];
}
- (void)OnLoadFail:(ASIDownManager *)sender {
    [self Cancel];
    [self showMsg:@"发布失败"];
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
