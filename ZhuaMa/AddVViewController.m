//
//  AddVViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/14.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "AddVViewController.h"
#import "ASIDownManager.h"
#import "RegexKitLite.h"
@interface AddVViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *mainSC;
    UITextField *textField;
    
    UIButton *zhengmianPic;
    UIButton *fanmianPic;
    
    UIImage *image;
    
    int flag;
    
    BOOL hasZhenmian;
    BOOL hasFanmian;
    
}
@property(nonatomic,strong)NSMutableArray *pickArray;
@property (nonatomic,strong)NSMutableDictionary *picDic;
@property(nonatomic,strong)ASIDownManager*mDownManager;
@end

@implementation AddVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = 0;
    hasFanmian = NO;
    hasZhenmian = NO;
    self.picDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.pickArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 100, 35) title:@"上传身份证" font:20];
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
    mainSC.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    [self.view addSubview:mainSC];
    
    UILabel *tishiLabel = [MyControll createLabelWithFrame:CGRectMake(20, 20, 120, 20) title:@"身份证号码" font:15];
    [mainSC addSubview:tishiLabel];
    
    UIView *bgView = [MyControll createViewWithFrame:CGRectMake(0, 55, WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:bgView];
    
    textField = [MyControll createTextFieldWithFrame:CGRectMake(20, 10, WIDTH - 40, 30) text:nil placehold:nil font:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:textField];
    
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 135, 220, 20) title:@"上传身份证反正面照片" font:15];
    [mainSC addSubview:tishi1];
    
    UIView *bgView1 = [MyControll createViewWithFrame:CGRectMake(0, 170, WIDTH, 100)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:bgView1];
    
    zhengmianPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 80, 80) bgImageName:nil imageName:@"kuang" title:nil selector:@selector(shenfenClick:) target:self];
    [bgView1 addSubview:zhengmianPic];
    
    fanmianPic = [MyControll createButtonWithFrame:CGRectMake(125, 10, 80, 80) bgImageName:nil imageName:@"kuang" title:nil selector:@selector(shenfenClick:) target:self];
    [bgView1 addSubview:fanmianPic];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(40, 290, WIDTH - 40 - 20, 40) title:@"请点击图片上传身份证反正面照片，拍摄照片或者从相册中选取图片" font:12];
    tishi2.textColor =[UIColor colorWithRed:0.61f green:0.61f blue:0.61f alpha:1.00f];
    [mainSC addSubview:tishi2];
    
    UIImageView *littleImageView = [MyControll createImageViewWithFrame:CGRectMake(20, 297, 15, 15) imageName:@"dian"];
    [mainSC addSubview:littleImageView];
    
    
    UIButton *finishBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH - 260)/2, 370, 260, 40) bgImageName:nil imageName:@"wanc" title:nil selector:@selector(finishClick:) target:self];
    [mainSC addSubview:finishBtn];
    
}
-(void)shenfenClick:(UIButton *)sender
{
    if (sender ==zhengmianPic) {
        flag = 0;
    }
    else
    {
        flag = 1;
    }
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机" ,nil];
    [sheet showInView:self.view];
}
-(void)finishClick:(UIButton *)sender
{
    if (textField.text.length==0) {
        [self showMsg:@"请输入身份证号码"];
        return;
    }
    else if(![self checkShenfenID:textField.text])
    {
        [self showMsg:@"身份证号码格式不正确"];
        return;
    }
    else if (!hasZhenmian) {
        [self showMsg:@"请上传身份证正面照片"];
        return;
    }
    else if (!hasFanmian)
    {
        [self showMsg:@"请上传身份证反面照片"];
        return;
    }
    [self commit];
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
    
    if (flag == 0) {
        [zhengmianPic setImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        hasZhenmian = YES;
        [self.picDic setObject:filePath forKey:@"zhengmian"];
    }
    else if (flag == 1)
    {

        [fanmianPic setImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        hasFanmian = YES;
        [self.picDic setObject:filePath forKey:@"fanmian"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//图片缩放
- (UIImage *)scaleToSize:(UIImage *)image :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
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

#pragma mark  完成提交
-(void)commit
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    
    NSString *zhenmian = self.picDic[@"zhengmian"];
    [self.pickArray addObject:zhenmian];
    NSString *fanmian = self.picDic[@"fanmian"];
    [self.pickArray addObject:fanmian];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@createv?uid=%@&token=%@&icid=%@",SERVER_URL,uid,token,textField.text];
    self.mDownManager= [[ASIDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    if (self.pickArray.count != 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i<self.pickArray.count; i++) {
            [dic setObject:self.pickArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
        }
        [_mDownManager PostHttpRequest:urlstr :nil files:dic];
    }
    else
    {
        [_mDownManager PostHttpRequest:urlstr :nil files:nil];
    }
}
-(void)OnLoadFinish:(ASIDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"申请加V成功,等待验证"];
            [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
        }
        else
        {
            [self showMsg:@"申请失败"];
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
#pragma mark  验证格式是否正确
-(BOOL)checkShenfenID:(NSString *)ID
{
    NSString * shenfenNum =@"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    if ([ID isMatchedByRegex:shenfenNum]) {
        return YES;
    }
        return NO;
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
