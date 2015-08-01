//
//  MyControll.h
//  LimitFree
//
//  Created by  on 14-9-27.
//  Copyright (c) 2014年 wangliya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyControll : NSObject

+(UIView *)createViewWithFrame:(CGRect)frame;
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
+(UIButton *)createButtonWithFrame:(CGRect)frame bgImageName:(NSString *)bgImageName imageName:(NSString *)imageName title:(NSString *)title selector:(SEL)method target:(id)target;
+(UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title font:(float)font;
+(CGFloat)isIOS7;
//画线
+ (UIView *)getLineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andSuperView:(UIView *)superView;

+(UIView *)createToolViewWithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array;
+(UIView *)createToolView2WithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array;
+(UIView *)createToolView3WithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array;
+(UIView *)createToolView4WithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array;
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placehold:(NSString *)placehold font:(float)font;
+(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height;
+ (NSString *)dayLabelForMessage:(NSDate *)msgDate;
+ (NSString *)stringFromDate:(NSDate *)date;
+(BOOL)checkGeShi:(NSString *)str Regex:(NSString *)reg;
@end
