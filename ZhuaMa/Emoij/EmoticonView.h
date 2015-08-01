//
//  EmoticonView.h
//  TestHebei
//
//  Created by LYD on 15/1/16.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol emoticonDelegate <NSObject>

- (void)emoticonViewSelectImage:(NSString *)image;
- (void)emoticonViewDeleteImage;

@end

@interface EmoticonView : UIScrollView

@property(nonatomic, assign)SEL selectImage;
@property(nonatomic, assign)SEL deleteImage;
@property(nonatomic, weak)__weak id<emoticonDelegate>emoticonDelegate;

//根据图片名返回图片路径
- (NSString *)imagePathFromName:(NSString *)imageName;

//图文混排
- (UIView *)viewWithText:(NSString *)text andFrame:(CGRect)rect FontSize:(float)font;
@property(nonatomic)float www;
@end
