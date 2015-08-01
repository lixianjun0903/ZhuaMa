//
//  BaseADViewController.h
//  TestDialogue
//
//  Created by Hepburn Alex on 13-2-6.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JSON.h"

@interface BaseADViewController : UIViewController {
    UILabel *mlbTitle;
    MBProgressHUD *mLoadView;
    id delegate;
    UIImageView *mLogoView;
//    MBProgressHUD *tipView;
}

@property (nonatomic, retain) NSString *mLoadMsg;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnGoBack;

//topbar
@property (nonatomic, readonly) UILabel *mlbTitle;
@property (nonatomic, retain) UIColor *mTitleColor;
@property (nonatomic, retain) UIColor *mTopColor;
@property (nonatomic, retain) UIImage *mTopImage;
@property (nonatomic, assign) BOOL mbLightNav;
@property (nonatomic, assign) int mFontSize;


//-(void)showTipView:(NSString *)msg;

- (void)GoBack;
- (void)GoHome;
- (void)StartLoading;
- (void)StopLoading;
- (void)showMsg:(NSString *)msg;

- (void)HideLogo;
- (void)ShowLogo:(int)iOffset;

- (void)ClearNavItem;
- (void)AddRightTextBtn:(NSString *)name target:(id)target action:(SEL)action;
- (void)AddRightImageBtn:(UIImage *)image target:(id)target action:(SEL)action;
- (void)AddLeftImageBtn:(UIImage *)image target:(id)target action:(SEL)action;
- (void)AddLeftTextBtn:(NSString *)text target:(id)target action:(SEL)action;
- (void)AddLeftImageBtn:(UIImage *)image andTitleBtn:(NSString *)title target:(id)target action:(SEL)action;

- (void)AddTitleView:(UIView *)titleView;

- (void)removeLeftTextBtn;

- (UIButton *)GetImageButton:(UIImage *)image target:(id)target action:(SEL)action;
- (UIBarButtonItem *)GetImageBarItem:(UIImage *)image target:(id)target action:(SEL)action;
- (void)AddRightImageBtns:(NSArray *)array;

- (void)RefreshNavColor;

- (UIView *)GetInputAccessoryView;
- (BOOL) IsEnableWIFI;
- (BOOL) IsEnable3G;
@end
