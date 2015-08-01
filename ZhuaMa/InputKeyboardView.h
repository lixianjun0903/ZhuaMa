//
//  InputKeyboardView.h
//  ZhuaMa
//
//  Created by xll on 15/1/21.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#include "EmoticonView.h"
@class InputKeyboardView;

@protocol inputKeyboardDelegate <NSObject>
//点击发送回调
- (void)inputKeyboardSendText:(NSString *)text;
//收起输入视图回调
- (void)inputKeyboardHide:(InputKeyboardView *)keyboardView;

@end


@interface InputKeyboardView : BaseADView<UITextViewDelegate,UIScrollViewDelegate,emoticonDelegate>
//所属视图控制器
@property(nonatomic, weak)UIViewController *mRootCtrl;
//代理
@property(nonatomic, weak)__weak id<inputKeyboardDelegate>delegate;
//显示视图
- (void)showInputkeyboard;
//隐藏视图
- (void)hideInputkeyboard;


@end
