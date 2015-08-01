//
//  InputKeyboardView.m
//  ZhuaMa
//
//  Created by xll on 15/1/21.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "InputKeyboardView.h"

@implementation InputKeyboardView
{
    
    UIButton *faceBtn;
    UIView *shadowView;
    UITextView *textView;
    UIImageView *bgView;
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
}
#pragma mark -------------------- 外部接口 -----------------------

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    
        }
    return self;
}
-(void)makeUI
{
    isSelect = NO;
    isDeleteView = NO;
    _emoticonArray = [[NSMutableArray alloc] init];
    _textRangeArray = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
    [self createEmoticonView];
    
    
    bgView = [MyControll createImageViewWithFrame:CGRectMake(0, self.frame.size.height, vWIDTH, 60) imageName:@"76"];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(55, 10, vWIDTH - 55 - 70, 40)];
    textView.layer.cornerRadius = 5;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:14];
    textView.clipsToBounds = YES;
        [textView becomeFirstResponder];
    [bgView addSubview:textView];
    
    faceBtn = [MyControll createButtonWithFrame:CGRectMake(20, 0, 25, 60) bgImageName:nil imageName:@"73" title:nil selector:@selector(faceClick:) target:self];
    [faceBtn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateSelected];
    faceBtn.selected = NO;
    [bgView addSubview:faceBtn];
    
    
    
    UIButton *sendBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH - 60, 0, 50, 60) bgImageName:nil imageName:@"75" title:nil selector:@selector(sendClick) target:self];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:sendBtn];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)createEmoticonView
{
    BQView  = [[UIView alloc]initWithFrame:CGRectMake(0, vHEIGHT, vWIDTH, 170)];
    BQView.hidden = YES;
    BQView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BQView];
    emoticonView = [[EmoticonView alloc]initWithFrame:CGRectMake(0, 10, vWIDTH, 120)];
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
-(void)faceClick:(UIButton *)sender
{
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
-(void)sendClick
{
    [_delegate inputKeyboardSendText:textView.text];
    [self removeView:nil];
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
            bgView.frame = CGRectMake(0,vHEIGHT - CGRectGetHeight(keyboardFrame)-60, vWIDTH, 60);
            BQView.frame = CGRectMake(0, vHEIGHT, vWIDTH, 170);
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
            BQView.frame = CGRectMake(0, vHEIGHT-170, vWIDTH, 170);
            bgView.frame = CGRectMake(0, vHEIGHT-170-60, vWIDTH, 60);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:duration-0.1 animations:^{
            BQView.hidden = YES;
            bgView.frame = CGRectMake(0, vHEIGHT, vWIDTH, 60);
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)textViewDidChange:(UITextView *)textView{
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
        [_emoticonArray removeLastObject];
        [_textRangeArray removeLastObject];
    }
}
#pragma mark   调用代理 删掉视图
-(void)removeView:(UIGestureRecognizer *)sender
{
    isDeleteView = YES;
    [_delegate inputKeyboardHide:self];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
