//
//  EmoticonView.m
//  TestHebei
//
//  Created by LYD on 15/1/16.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import "EmoticonView.h"

@implementation EmoticonView{
    NSDictionary *_emoticonDict;
    NSArray *_keys;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
    _emoticonDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _keys = [_emoticonDict allKeys];
    
    CGFloat view_width = self.frame.size.width/7;
    CGFloat view_height = self.frame.size.height/4;
    
    
    int n=0;
    for (int i=0; i<[_keys count]; n++) {
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(n*self.frame.size.width, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:baseView];
        
        for (int j=0; j<28 && i<_keys.count; j++,i++) {
            
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            imageBtn.frame = CGRectMake(j%7*view_width, j/7*view_height, view_width, view_height);
            imageBtn.tag = i;
            [baseView addSubview:imageBtn];
            
            if (j==27 || i==_keys.count) {
                [imageBtn addTarget:self action:@selector(imageDelete:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((imageBtn.frame.size.width-27)/2, (imageBtn.frame.size.height-20)/2, 27, 20)];
                image.image = [UIImage imageNamed:@"DeleteEmoticonBtn_ios7"];
                [imageBtn addSubview:image];
                break;
            }else{
                [imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((imageBtn.frame.size.width-25)/2, (imageBtn.frame.size.height-25)/2, 25, 25)];
                image.image = [UIImage imageNamed:[_emoticonDict objectForKey:[_keys objectAtIndex:i]]];
                [imageBtn addSubview:image];
                
            }
        }
    }
}

//选中图片
- (void)btnClick:(UIButton *)btn {
    NSLog(@"选中图片");
    NSString *key = [_keys objectAtIndex:btn.tag];
    NSString *imageName = key;
    [((UIViewController *)self.delegate) performSelector:_selectImage withObject:imageName afterDelay:0];
}

//删除图片
- (void)imageDelete:(UIButton *)btn {
    if (_emoticonDelegate && [_emoticonDelegate respondsToSelector:@selector(emoticonViewDeleteImage)]) {
        [_emoticonDelegate emoticonViewDeleteImage];
    }
    [((UIViewController *)self.delegate) performSelector:_deleteImage withObject:nil afterDelay:0];

}

#pragma mark ---------------------------------------- 图文混排 ---------------------------------------------
//图文混排
- (UIView *)viewWithText:(NSString *)text andFrame:(CGRect)rect FontSize:(float)font
{
    
    //NSLog(@"text ========================== %@",text);
    
    UIView *baseView = [[UIView alloc] initWithFrame:rect];
    //找出图片在文字中的位置
    NSMutableArray *rangeArr = [[NSMutableArray alloc] init];
    int i=0;
    while (i<text.length) {
        
        int location = -1;
        int length = -1;
        int j;
        for (j=i; j<text.length; j++) {
            char ch = [text characterAtIndex:j];
            if (ch == '[') {
                location = j;
            }else if (ch == ']'){
                length = j-location+1;
                i=j+1;
                break;
            }
        }
        
        if (location != -1 && length != -1) {
            NSRange range = NSMakeRange(location, length);
            [rangeArr addObject:NSStringFromRange(range)];
        }else{
            if (j == text.length) {
                break;
            }
        }
    }
    
    //NSLog(@"rangeArr ==== %@",rangeArr);
    CGFloat view_x = 0;
    CGFloat view_y = 0;
    CGFloat view_width = 10;
    CGFloat view_height = 22;
    
    //判断是否有文字
    if (rangeArr.count == 0) {//没有图片
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(CGRectGetWidth(baseView.frame), 1000) lineBreakMode:NSLineBreakByCharWrapping];
//        baseView.frame = CGRectMake(baseView.frame.origin.x, baseView.frame.origin.y, size.width, size.height);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(view_x, view_y, size.width, size.height)];
        lable.lineBreakMode = NSLineBreakByCharWrapping;
        lable.numberOfLines = 0;
        lable.font = [UIFont systemFontOfSize:font];
        lable.text = text;
        [baseView addSubview:lable];
        view_width = size.width;
        view_height = size.height;
        _www = size.width;
        
    }else{//有图片
        //记住上一个子串结束的位置
        NSInteger site = 0;
        
        //开始图文混排
        for (NSString *rangeStr in rangeArr) {
            
            NSRange range = NSRangeFromString(rangeStr);
            
            //判断从上一个子串结束的位置到本次图片开始的位置中间是否有文字
            NSMutableString *subStr = [NSMutableString stringWithString:[text substringWithRange:NSMakeRange(site, range.location-site)]];
            if (subStr.length > 0) {//有文字
                while (1) {
                    
                    //NSLog(@"str =================== %@",subStr);
                    //计算文字不换行时的宽度
                    CGSize size1 = [subStr sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, view_height)];
                    
                    NSString *str = [self changeLine:subStr limitLength:(CGRectGetWidth(baseView.frame)-view_x) withFont:font];
                    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(view_x, view_y, size1.width, size1.height)];
                    lable.text = str;
                    lable.font = [UIFont systemFontOfSize:font];
                    [baseView addSubview:lable];
                    
                    NSLog(@"subStr ==== %@",subStr);
                    NSLog(@"str ==== %@",str);
                    NSLog(@"[subStr rangeOfString:str] ==== %@",NSStringFromRange([subStr rangeOfString:str]));
                    
                    if (view_x+size1.width <= CGRectGetWidth(baseView.frame)) {
                        view_x = CGRectGetMaxX(lable.frame);
                        _www = view_x+size1.width+20;
                        break;
                    }
                    
                    [subStr deleteCharactersInRange:[subStr rangeOfString:str]];
                    view_x = 0.0;
                    view_y += size1.height+3;
                    
                }
            }
            
            //设置图片
            if (CGRectGetWidth(baseView.frame)-view_x < 17) {
                view_x = 0;
                view_y += 20;
            }
            
            NSString *imagePath = [self imagePathFromName:[text substringWithRange:range]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view_x, view_y, 17, 17)];
            imageView.image = [UIImage imageNamed:imagePath];
            [baseView addSubview:imageView];
            
            site = range.location + range.length;
            view_x += 17;
        }
    }
    CGRect frame = baseView.frame;
    frame.size.height = view_y+view_height;
    baseView.frame  = frame;
    
    if (frame.size.height>25) {
        _www = baseView.frame.size.width;
    }
    return baseView;
}


//返回刚刚没超出范围的子串
- (NSString *)changeLine:(NSString *)str limitLength:(float)limWidth withFont:(float)font{
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:str];
    
    int length = 1;
    while (1) {
        
        NSRange range = NSMakeRange(0, length);
        NSString *subStr = [mStr substringWithRange:range];
        CGSize size = [subStr sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
        if (size.width>limWidth) {
            length--;
            break;
        }else if (length == str.length){
            break;
        }
        length++;
    }
    NSLog(@"str =============== %@,,,,length ======= %d",str,length);
    
    return [mStr substringWithRange:NSMakeRange(0, length)];
    
}

//根据图片名返回图片路径
- (NSString *)imagePathFromName:(NSString *)imageName{
    //获取所有的表情图
    if (!_emoticonDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
        _emoticonDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    NSString *imagePath = [_emoticonDict objectForKey:imageName];
    return imagePath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
