//
//  PressViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/26.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "PressBaoliaoViewController.h"
#import "ASIDownManager.h"
@interface PressBaoliaoViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UITextView *textView;
    UIView *picView;
    UIImageView *imageView;
    
    UIImage *image;
    int picNum;
    UIButton *photoBtn;
    BOOL isNiMing;
}
@property(nonatomic,strong)NSMutableArray *pickArray;
@property(nonatomic,strong)ASIDownManager *mDownManager;
@end

@implementation PressBaoliaoViewController

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
    isNiMing = NO;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    self.pickArray =[NSMutableArray arrayWithCapacity:3];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"吐槽/爆料" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"发布" selector:@selector(press) target:self];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self makeUI];
    [self createBottomView];
}
-(void)press
{
    if (textView.text.length == 0) {
        [self showMsg:@"发表文章不能为空"];
        return;
    }
    else
    {
        [self loadData];
    }

}
#pragma mark  主UI
-(void)makeUI
{
   
    textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 10, WIDTH - 10, 120)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
    textView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    UILabel *tishiLabel = [MyControll createLabelWithFrame:CGRectMake(5, 10, WIDTH-10, 20) title:@"快来吐槽下吧！" font:15];
    tishiLabel.tag = 1;
    tishiLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tishiLabel];
    
    picView = [MyControll createViewWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 100)];
    [self.view addSubview:picView];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UILabel *tishi = (UILabel *)[self.view viewWithTag:1];
    tishi.hidden = YES;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView1
{
    NSString *str = textView1.text;
    if (str.length==0) {
        UILabel *tishi = (UILabel *)[self.view viewWithTag:1];
        tishi.hidden = NO;
    }
}
-(BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
#pragma mark  创建botttomView
-(void)createBottomView
{
    imageView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT - 64, WIDTH, 50) imageName:@"45"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UIButton *faceBtn = [MyControll createButtonWithFrame:CGRectMake(20, 0, 30, 50) bgImageName:nil imageName:@"77" title:nil selector:@selector(faceClick) target:self];
    [imageView addSubview:faceBtn];
    
    photoBtn = [MyControll createButtonWithFrame:CGRectMake(85, 0, 30, 50) bgImageName:nil imageName:@"78" title:nil selector:@selector(photoClick) target:self];
    [imageView addSubview:photoBtn];
    
    UILabel *huamingLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2 + 30, 0, 80, 50) title:@"花名发布" font:15];
    [imageView addSubview:huamingLabel];
    
    
    UIButton *nimingBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-60, 0, 30, 50) bgImageName:nil imageName:@"57" title:nil selector:@selector(nimingClick:) target:self];
    [nimingBtn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
    [imageView addSubview:nimingBtn];
    
    
    UIButton *keyboard = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 25, 0, 23, 50) bgImageName:nil imageName:@"9" title:nil selector:@selector(hideKeyboard) target:self];
    [imageView addSubview:keyboard];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)nimingClick:(UIButton *)sender
{
    isNiMing = !isNiMing;
    if (isNiMing) {
        sender.selected = YES;
    }
    else
    {
        sender.selected = NO;
    }
}
-(void)hideKeyboard
{
    [textView resignFirstResponder];
}
-(void)faceClick
{
    
}
-(void)showPic
{
    for (int i= 0; i<self.pickArray.count; i++) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        UIImage *img = [UIImage imageWithContentsOfFile:self.pickArray[i]];
        UIImageView *imageView1 = [MyControll createImageViewWithFrame:CGRectMake(20+i*90, 10, 80, 80) imageName:nil];
        imageView1.tag = 6000+i;
        imageView1.image = img;
        [imageView1 addGestureRecognizer:longPress];
        [picView addSubview:imageView1];
        
    }
}
#pragma mark  --------------------
-(void)longPress:(UIGestureRecognizer *)sender
{
    
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
                UIImageView *imageView1 = (UIImageView *)[picView viewWithTag:6000+i];
                [imageView1 removeFromSuperview];
                imageView1 = nil;
            }
            [self.pickArray removeObjectAtIndex:picNum];
            [self showPic];
        }
        
    }
}
#pragma mark  获取图片
-(void)photoClick
{
    [self hideKeyboard];
    if (self.pickArray.count>=3) {
        [self showMsg:@"最多可加入3张图片，不能添加了"];
        return;
    }
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
        UIImageView *imageView1 = (UIImageView *)[picView viewWithTag:6000+i];
        [imageView1 removeFromSuperview];
        imageView1 = nil;
    }
    [self.pickArray addObject:filePath];
    [self showPic];
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
#pragma mark  键盘管理
-(void)keyboardShow:(NSNotification *)notification
{
    //计算键盘高度
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = CGRectMake(0, HEIGHT - height - 50, self.view.frame.size.width, 50);
    }];
    
}
-(void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame =  CGRectMake(0, HEIGHT - 50, WIDTH, 50);
    }];
}
-(CGSize )getSize:(NSString *)str
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width -10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(self.view.frame.size.width - 10, 1000)];
    }
    return size;
}
#pragma mark  发布爆料
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    int num;
    if (isNiMing) {
        num = 1;
    }
    else
    {
        num = 0;
    }
    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@createbid?uid=%@&token=%@&text=%@&flag=%d",SERVER_URL,uid,token,str,num];
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pressBLSuccess" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)OnLoadFail:(ASIDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
