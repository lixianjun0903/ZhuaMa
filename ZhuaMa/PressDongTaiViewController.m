//
//  PressDongTaiViewController.m
//  ZhuaMa
//
//  Created by xll on 15/2/3.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PressDongTaiViewController.h"
#import "EmoticonView.h"
#import "ASIDownManager.h"
#import "PicSelectView.h"
@interface PressDongTaiViewController ()<UITextViewDelegate,UIScrollViewDelegate,emoticonDelegate,PicSelectDelegate>
{
    UIImageView *imageView;
    UILabel *tishiLabel;
    
    UIButton *faceBtn;
    UITextView *textView;
    EmoticonView *emoticonView;
    UIPageControl *pageControl;
    
    
    //存储emoticon图片的数组
    NSMutableArray *_emoticonArray;
    //存储图片的名字在textView中得位置
    NSMutableArray *_textRangeArray;
    
    UIView *BQView;
    BOOL IsBQshow;
    BOOL isSelect;
    BOOL isDeleteView;
    
    
    UIView *picView;
    int deletePicNum;
}
@property(nonatomic,strong)NSMutableArray *pickArray;
@property(nonatomic,strong)ASIDownManager *mDownManager;
@end

@implementation PressDongTaiViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"发动态" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"发布" selector:@selector(press) target:self];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //    [self AddRightImageBtn:[UIImage imageNamed:@"47@2x.png"] target:self action:@selector(press)];
    
    [self makeUI];
    [self createBottomView];
}
-(void)tap:(UIGestureRecognizer *)sender
{
     isDeleteView = YES;
    if (isSelect) {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
            BQView.frame = CGRectMake(0, HEIGHT, WIDTH, 170);
        } completion:^(BOOL finished) {
            BQView.hidden = YES;
        }];
    }
    else
    {
        [self.view endEditing:YES];
    }
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
-(void)makeUI
{
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 10, WIDTH - 10, 120)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
    textView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [self.view addSubview:textView];
    tishiLabel = [MyControll createLabelWithFrame:CGRectMake(5, 17, WIDTH-10, 20) title:@"  说点圈内相关动态吧！" font:15];
    tishiLabel.tag = 1;
    tishiLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tishiLabel];
    
    picView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 80)];
    [self.view addSubview:picView];
    
    
    
    
    isSelect = YES;
    isDeleteView = NO;
    _emoticonArray = [[NSMutableArray alloc] init];
    _textRangeArray = [[NSMutableArray alloc] init];

    
    [self createEmoticonView];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)createEmoticonView
{
    BQView  = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 170)];
    BQView.hidden = YES;
    BQView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BQView];
    emoticonView = [[EmoticonView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 120)];
    emoticonView.contentSize = CGSizeMake(CGRectGetWidth(BQView.frame)*3, 120);
    emoticonView.delegate = self;
    emoticonView.emoticonDelegate = self;
    emoticonView.selectImage = @selector(emoticonViewSelectImage:);
    emoticonView.deleteImage = @selector(emoticonViewDeleteImage);
    emoticonView.pagingEnabled = YES;
    emoticonView.showsHorizontalScrollIndicator = NO;
    emoticonView.showsVerticalScrollIndicator = NO;
    emoticonView.backgroundColor = [UIColor whiteColor];
    [BQView addSubview:emoticonView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(BQView.frame)-20, CGRectGetWidth(BQView.frame), 15)];
    pageControl.numberOfPages = 3;
    pageControl.tintColor = [UIColor blackColor];
    [BQView addSubview:pageControl];
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}
-(void)createBottomView
{
    imageView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT - 64-50, WIDTH, 50) imageName:@"45"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    faceBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2 - 30)/2, 0, 30, 50) bgImageName:nil imageName:@"77" title:nil selector:@selector(faceClick:) target:self];
    [faceBtn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateSelected];
    faceBtn.selected = YES;
    [imageView addSubview:faceBtn];
    
    UIButton * photoBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH/2 + (WIDTH/2 - 30)/2, 0, 30, 50) bgImageName:nil imageName:@"78" title:nil selector:@selector(photoClick) target:self];
    [imageView addSubview:photoBtn];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)photoClick
{
    [self tap:nil];
    PicSelectView *picSelectView = [[PicSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    picSelectView.tag = 703;
    picSelectView.delegate = self;
    picSelectView.maxCount = 3-self.pickArray.count;
    [self.tabBarController.view addSubview:picSelectView];
}
-(void)picSelect:(PicSelectView *)picSelectView1 Camera:(NSString *)filePath Album:(NSMutableArray *)array Flag:(int)flag
{
    if (flag == 1) {
        [self.pickArray addObject:filePath];
        [self refreshUI];
    }
    else if (flag == 2)
    {
        [self.pickArray addObjectsFromArray:array];
        [self refreshUI];
    }
    PicSelectView *picSelectView = (PicSelectView *)[self.tabBarController.view viewWithTag:703];
    [picSelectView removeFromSuperview];
}
-(void)refreshUI
{
    for (UIView *view in picView.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<self.pickArray.count; i++) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+i*73.3, 10, 60, 60) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.pickArray[i]];
            [tempImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            tempImageView.tag = 300+i;
            [picView addSubview:tempImageView];
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
        [self.pickArray removeObjectAtIndex:deletePicNum];
        [self refreshUI];
    }
}
-(void)faceClick:(UIButton *)sender
{   isDeleteView = NO;
    isSelect = !isSelect;
    if (isSelect) {
        IsBQshow = YES;
        sender.selected = YES;
        [textView resignFirstResponder];
    }
    else
    {
        sender.selected = NO;
        [textView becomeFirstResponder];
    }
}
-(void)keyboardWillShow:(NSNotification *)notification
{
    faceBtn.selected = NO;
    isSelect = NO;
    //获取键盘的参数
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (duration == 0) {
        duration = 0.1;
    }
    
    NSLog(@"dict ======= %@",dict);
    NSLog(@"keyboardFrame ====== %@",NSStringFromCGRect(keyboardFrame));
    NSLog(@"CGRectGetMinY(keyboardFrame) ===== %f",CGRectGetMinY(keyboardFrame));
    //    if (IsBQshow) {
    [UIView animateWithDuration:duration animations:^{
        imageView.frame = CGRectMake(0,HEIGHT - CGRectGetHeight(keyboardFrame)-50, WIDTH, 50);
        BQView.frame = CGRectMake(0, HEIGHT-64, WIDTH, 170);
    } completion:^(BOOL finished) {
        if (finished) {
            BQView.hidden = YES;
        }
    }];
    
    //    }
    //    else
    //    {
    //        [UIView animateWithDuration:duration animations:^{
    //            bgView.frame = CGRectMake(0,vHEIGHT - CGRectGetHeight(keyboardFrame)-60, vWIDTH, 60);
    //        } completion:^(BOOL finished) {
    //            if (finished) {
    //
    //            }
    //        }];
    //    }
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    faceBtn.selected = YES;
    isSelect = YES;
    NSDictionary *dict = [notification userInfo];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (!isDeleteView) {
        [UIView animateWithDuration:duration-0.1 animations:^{
            BQView.hidden = NO;
            BQView.frame = CGRectMake(0, HEIGHT-170, WIDTH, 170);
            imageView.frame = CGRectMake(0, HEIGHT-170-50, WIDTH, 50);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:duration-0.1 animations:^{
            BQView.hidden = YES;
            imageView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)textViewDidChange:(UITextView *)textView1{
    if (textView.text.length>0) {
        tishiLabel.hidden =YES;
    }
    else
    {
        tishiLabel.hidden = NO;
    }
    //    NSLog(@"textView.text ==== %@",textView.text);
}

- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"text ==== %@",text);
    NSLog(@"textView.text ==== %@",textView.text);
    NSLog(@"range ==== %@",NSStringFromRange(range));
    
    if (range.length == 1) {
        
        int index=0;
        for (NSString *rangeStr in _textRangeArray) {
            NSRange imageRange = NSRangeFromString(rangeStr);
            
            //如果删除的是图片的名字
            if (NSLocationInRange(range.location, imageRange)) {
                
                NSMutableString *tempText = [[NSMutableString alloc] initWithString:textView.text];
                [tempText deleteCharactersInRange:imageRange];
                textView.text = tempText;
                
                //控制光标的位置
                textView.selectedRange = imageRange;
                
                //重新设置image的range
                int length = imageRange.length;
                for (int i=index+1; i<_textRangeArray.count; i++) {
                    NSRange tempRange = NSRangeFromString([_textRangeArray objectAtIndex:i]);
                    tempRange = NSMakeRange(tempRange.location-length, tempRange.length);
                }
                
                //删除image
                [_textRangeArray removeObjectAtIndex:index];
                [_emoticonArray removeObjectAtIndex:index];
                return NO;
            }
            index++;
        }
    }
    return YES;
}

#pragma mark ----------------------------------- UIScrollView的协议方法 -------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == emoticonView) {
        int index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        pageControl.currentPage = index;
    }
}
//添加图片回调
- (void)emoticonViewSelectImage:(NSString *)imageName{
    NSLog(@"image ====== %@",imageName);
    NSString *text = [NSString stringWithFormat:@"%@%@",textView.text,imageName];
    textView.text = text;
    if (textView.text.length>0) {
        tishiLabel.hidden= YES;
    }
    
    //记住图片名字在字典中得位置
    NSRange range = [text rangeOfString:imageName options:NSBackwardsSearch];
    [_textRangeArray addObject:NSStringFromRange(range)];
    [_emoticonArray addObject:imageName];
    
    NSLog(@"range ==== %@",NSStringFromRange(range));
}

//删除图片回调
- (void)emoticonViewDeleteImage{
    if (_emoticonArray.count>0) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:textView.text];
        
        NSString *deleteStr = [_emoticonArray lastObject];
        NSRange range = [text rangeOfString:deleteStr options:NSBackwardsSearch];
        
        [text deleteCharactersInRange:range];
        textView.text = text;
        if (textView.text.length==0) {
            tishiLabel.hidden = NO;
        }
        [_emoticonArray removeLastObject];
        [_textRangeArray removeLastObject];
    }
}
#pragma mark  发布通告
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@createtopic?uid=%@&token=%@&text=%@",SERVER_URL,uid,token,str];
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pressSuccess" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)OnLoadFail:(ASIDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}


#pragma mark   调用代理 删掉视图
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
