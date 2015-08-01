//
//  BaseADViewController.m
//  TestDialogue
//
//  Created by Hepburn Alex on 13-2-6.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "SelectTabBar.h"
#import "Reachability.h"
@interface BaseADViewController ()

@end

@implementation BaseADViewController
{
    //左边文字按钮
    UIButton *_leftTextBtn;
    //
    NSMutableArray *_leftTextArray;
}


@synthesize mlbTitle, delegate, OnGoBack, mTopColor, mTopImage, mLoadMsg, mTitleColor, mbLightNav, mFontSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mbLightNav = YES;
        mFontSize = 20;
        self.mTopImage = [UIImage imageNamed:IOS_7?@"1@2x.png":@"topbar.png"];
        self.mTopColor = kDefault_Color;
        self.mTitleColor = [UIColor whiteColor];
        //self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
        _leftTextArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)GoHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GoBack {
    if (delegate && OnGoBack) {
        [delegate performSelector:OnGoBack withObject:self];
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)RefreshNavColor {
    if (mTopColor) {
        if (IOS_7) {
            self.navigationController.navigationBar.barTintColor = mTopColor;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        else {
            self.navigationController.navigationBar.tintColor = mTopColor;
        }
    }
    if (mTopImage) {
        [self.navigationController.navigationBar setBackgroundImage:mTopImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        //去掉边缘化 适配
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (!mbLightNav) {
            self.navigationController.navigationBar.translucent = NO;
        }
    }
    [self RefreshNavColor];

    mlbTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-100, 44)];
    mlbTitle.backgroundColor = [UIColor clearColor];
    mlbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:mFontSize];
    mlbTitle.textAlignment = UITextAlignmentCenter;
    mlbTitle.textColor = self.mTitleColor;
    mlbTitle.text = self.title;
    self.navigationItem.titleView = mlbTitle;
    [mlbTitle release];
    
    
    [self AddLeftImageBtn:nil target:nil action:nil];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    //////////////////////////
}

- (void)ClearNavItem {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (UIButton *)GetImageButton:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    int iWidth = image.size.width/2;
    int iHeight = image.size.height/2;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((40-iWidth)/2, (40-iHeight)/2, iWidth, iHeight);
    imageView.tag = 1300;
    [rightBtn addSubview:imageView];
    [imageView release];
    
    return rightBtn;
}

- (UIBarButtonItem *)GetImageBarItem:(UIImage *)image target:(id)target action:(SEL)action {
    int iBtnWidth = IOS_7?30:40;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, iBtnWidth, 40);
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    int iWidth = image.size.width/2;
    int iHeight = image.size.height/2;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake((iBtnWidth-iWidth)/2, (40-iHeight)/2, iWidth, iHeight);
    imageView.tag = 1300;
    [rightBtn addSubview:imageView];
    [imageView release];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
}

- (UIBarButtonItem *)GetTextBarItem:(NSString *)name target:(id)target action:(SEL)action {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:name forState:UIControlStateNormal];
    [rightBtn setTitleColor:self.mTitleColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
}

- (void)AddLeftImageBtn:(UIImage *)image target:(id)target action:(SEL)action {
    self.navigationItem.leftBarButtonItem = [self GetImageBarItem:image target:target action:action];
}

- (void)AddLeftImageBtn:(UIImage *)image andTitleBtn:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *btn1 = [self GetImageBarItem:image target:target action:action];
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
    NSArray *items = [[NSArray alloc] initWithObjects:btn1,btn2, nil];
    self.navigationItem.leftBarButtonItems = items;
}

- (void)AddRightImageBtn:(UIImage *)image target:(id)target action:(SEL)action {
    self.navigationItem.rightBarButtonItem = [self GetImageBarItem:image target:target action:action];
}

- (void)AddRightImageBtns:(NSArray *)array {
    if (!array || array.count == 0) {
        return;
    }
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, array.count*40, 40)] autorelease];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [array objectAtIndex:i];
        btn.frame = CGRectMake(i*40, 0, 40, 40);
        [view addSubview:btn];
    }
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
}


- (void)AddRightTextBtn:(NSString *)name target:(id)target action:(SEL)action {
    self.navigationItem.rightBarButtonItem = [self GetTextBarItem:name target:target action:action];
}

- (void)AddLeftTextBtn:(NSString *)text target:(id)target action:(SEL)action{
    _leftTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftTextBtn.frame = CGRectMake(35, 6, 40, 30);
    _leftTextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftTextBtn setTitle:text forState:UIControlStateNormal];
    [_leftTextBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_leftTextBtn];
    [_leftTextArray addObject:_leftTextBtn];
}

- (void)removeLeftTextBtn{
    
    if (_leftTextBtn != nil && _leftTextBtn != NULL) {
        [_leftTextBtn removeFromSuperview];
        _leftTextBtn = nil;
    }
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    mlbTitle.text = title;
}

- (void)AddTitleView:(UIView *)titleView {
    self.navigationItem.titleView = titleView;
}

- (UIView *)GetInputAccessoryView {
    UIView *inputView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)] autorelease];
    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    [btn setTitle:@"隐藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(OnHideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:btn];

    return inputView;
}

- (void)OnHideKeyboard {
    [self.view endEditing:NO];
}

- (void)dealloc {
    self.mTopColor = nil;
    self.mTopImage = nil;
    self.mLoadMsg = nil;
    [self removeLeftTextBtn];
    [super dealloc];
}

- (void)ShowLogo:(int)iOffset {
    if (mLogoView) {
        return;
    }
    int iWidth = 150;
    int iHeight = 130;
    mLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-iWidth)/2, (self.view.frame.size.height-iHeight)/2+iOffset, iWidth, iHeight)];
    mLogoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mLogoView.backgroundColor = [UIColor redColor];
    mLogoView.image = [UIImage imageNamed:@"default_logo.png"];
    [self.view addSubview:mLogoView];
}

- (void)HideLogo {
    if (mLogoView) {
        [mLogoView removeFromSuperview];
        mLogoView = nil;
    }
}

- (void)StartLoading
{
    if (mLoadView) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
        mLoadView.labelText = mLoadMsg;
    }
    [self.view addSubview:mLoadView];
    mLoadView.dimBackground = YES;
    [mLoadView release];
    
    [mLoadView show:YES];
}

- (void)StopLoading
{
    [mLoadView hide:YES];
    mLoadView.dimBackground = NO;
    mLoadView = nil;
}

- (void)showMsg:(NSString *)msg
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:mLoadView];
    
    
	mLoadView.mode = MBProgressHUDModeCustomView;
	mLoadView.labelText = msg;
	[mLoadView show:YES];
	[mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
    [mLoadView release];
}
- (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否3G
- (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[SelectTabBar Share].hidden = YES;
}
//-(void)showTipView:(NSString *)msg
//{
//    tipView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    tipView.mode = MBProgressHUDModeText;
//    tipView.labelText = msg;
//    tipView.margin = 10.f;
//    tipView.yOffset = 150.f;
//    tipView.removeFromSuperViewOnHide = YES;
//    [tipView hide:YES afterDelay:2];
//    tipView = nil;
//    [tipView release];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
