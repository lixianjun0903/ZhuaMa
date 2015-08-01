//
//  MyControll.m
//  LimitFree
//
//  Created by 王立亚 on 14-9-27.
//  Copyright (c) 2014年 wangliya. All rights reserved.
//

#import "MyControll.h"
#import "NSDate-Utilities.h"
#import "RegexKitLite.h"
@implementation MyControll
//UIView
+(UIView *)createViewWithFrame:(CGRect)frame
{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    return view;
}

//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    if(imageName){
        imageView.image = [UIImage imageNamed:imageName];
    }
    imageView.userInteractionEnabled = YES;
    return imageView;
}

//UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame bgImageName:(NSString *)bgImageName imageName:(NSString *)imageName title:(NSString *)title selector:(SEL)method target:(id)target
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if(bgImageName){
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if(imageName){
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if(title){
        [button setTitle:title forState:UIControlStateNormal];
    }
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

//UILabel
+(UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title font:(float)font
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
    
}

//判断navigation的高度
+(CGFloat)isIOS7
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        return 64;
    }
    else{
        return 44;
    }
        
}
+ (UIView *)getLineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andSuperView:(UIView *)superView{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [superView addSubview:line];
    return line;
}
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placehold:(NSString *)placehold font:(float)font
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.text = text;
    textField.placeholder = placehold;
    textField.font = [UIFont systemFontOfSize:font];
    return textField;
}
+(UIView *)createToolViewWithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
//    view.layer.shadowOffset = CGSizeMake(1, 1);
//    view.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    view.backgroundColor = color;
//    view.layer.shadowOpacity = 0.8;
//    view.layer.shadowRadius = 0.5;
    int count;
    if (array.count != 0) {
        count = (int)array.count;
    }
    else
    {
        count = 1;
    }
    int height = frame.size.height/count;
    
    for (int i = 0; i<count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20 , i * height, view.frame.size.width/5 * 4, height)];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(view.frame.size.width - 40, i * height, 20, height) imageName:@"右箭头.png"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    
    for (int i =1 ; i < count; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, i * height, view.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:235.0/256 green:234.0/256 blue:238.0/256 alpha:1];
        [view addSubview:line];
    }
    
    return view;
}
+(UIView *)createToolView2WithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
//    view.layer.shadowOffset = CGSizeMake(1, 1);
//    view.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    view.backgroundColor = color;
//    view.layer.shadowOpacity = 0.8;
//    view.layer.shadowRadius = 0.5;
    int count;
    if (array.count != 0) {
        count = (int)array.count;
    }
    else
    {
        count = 1;
    }
    int height = frame.size.height/count;
    
    for (int i = 0; i<count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20 , i * height, view.frame.size.width/5, height)];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentJustified;
        
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
    }
    
    for (int i =1 ; i < count; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, i * height, view.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:235.0/256 green:234.0/256 blue:238.0/256 alpha:1];
        [view addSubview:line];
    }
    
    return view;
}
+(UIView *)createToolView3WithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
//    view.layer.shadowOffset = CGSizeMake(1, 1);
//    view.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    view.backgroundColor = color;
//    view.layer.shadowOpacity = 0.8;
//    view.layer.shadowRadius = 0.5;
    int count;
    if (array.count != 0) {
        count = (int)array.count;
    }
    else
    {
        count = 1;
    }
    int height = frame.size.height/count;
    
    for (int i = 0; i<count; i++) {
        UILabel *label;
        if (i==0) {
            label = [[UILabel alloc]initWithFrame:CGRectMake(20 , i * height, view.frame.size.width/5, height + 40)];
        }
        else{
            label = [[UILabel alloc]initWithFrame:CGRectMake(20 , i * height+40, view.frame.size.width/5, height)];
        }
        
        label.text = array[i];
        label.textAlignment = NSTextAlignmentJustified;
        
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
    }
    
    for (int i =1 ; i < count; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, i * height+40, view.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:235.0/256 green:234.0/256 blue:238.0/256 alpha:1];
        [view addSubview:line];
    }
    view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+40);
    return view;
}
+(UIView *)createToolView4WithFrame:(CGRect)frame withColor:(UIColor *)color withNameArray:(NSArray *)array
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    //    view.layer.shadowOffset = CGSizeMake(1, 1);
    //    view.layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    view.backgroundColor = color;
    //    view.layer.shadowOpacity = 0.8;
    //    view.layer.shadowRadius = 0.5;
    int count;
    if (array.count != 0) {
        count = (int)array.count;
    }
    else
    {
        count = 1;
    }
    int height = frame.size.height/count;
    
    for (int i = 0; i<count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20 , i * height, view.frame.size.width/2-20, height)];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentJustified;
        
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
    }
    
    for (int i =1 ; i < count; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, i * height, view.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:235.0/256 green:234.0/256 blue:238.0/256 alpha:1];
        [view addSubview:line];
    }
    
    return view;
}
+(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:sizeofstr]constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
}
+ (NSString *)dayLabelForMessage:(NSDate *)msgDate
{
    NSString *retStr = @"";
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *time = [formatter stringFromDate:msgDate];
    
    if ([msgDate isToday])
    {
        retStr = [NSString stringWithFormat:@"今天 %@",time];
    }
    else if ([msgDate isYesterday])
    {
        retStr = [NSString stringWithFormat:@"昨天 %@" ,time];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *time = [formatter stringFromDate:msgDate];
        retStr = [NSString stringWithFormat:@"%@" ,time];
    }
    return retStr;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
+(BOOL)checkGeShi:(NSString *)str Regex:(NSString *)reg
{
    if ([str isMatchedByRegex:reg]) {
        return YES;
    }
    return NO;
}
@end
