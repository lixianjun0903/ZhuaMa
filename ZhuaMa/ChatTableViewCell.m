//
//  ChatTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UserInfoManager.h"
@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    
    UIImageView *timeBgView = [MyControll createImageViewWithFrame:CGRectMake((self.contentView.frame.size.width - 80)/2, 5, 80, 20) imageName:@"ddd"];
    [self.contentView addSubview:timeBgView];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 80, 20) title:nil font:13];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    [timeBgView addSubview:timeLabel];
    //左边
    //头像
    leftHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 50, 50)];
    //削成圆角
    leftHeaderImageView.layer.cornerRadius = 5;
    //裁剪多余的
    leftHeaderImageView.layer.masksToBounds = YES;
    
    leftHeaderImageView.image = [UIImage imageNamed:@"35.jpg"];
    
    [self.contentView addSubview:leftHeaderImageView];
    
    //气泡
    leftBubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //处理气泡图片
    UIImage * leftImage = [UIImage imageNamed:@"d"];
    //设置拉伸规则,以某一像素点进行拉伸
    leftImage = [leftImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    leftBubbleImageView.image = leftImage;
    
    [self.contentView addSubview:leftBubbleImageView];
    
    //文字
    leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    leftLabel.numberOfLines = 0;
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [leftBubbleImageView addSubview:leftLabel];
    
    //右边
    rightHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-60, 40, 50, 50)];
    rightHeaderImageView.image = [UIImage imageNamed:@"90"];
    //处理圆角
    rightHeaderImageView.layer.cornerRadius = 5;
    rightHeaderImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:rightHeaderImageView];
    
    rightBubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage * rightImage = [UIImage imageNamed:@"dd"];
    //设置拉伸
    rightImage = [rightImage stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    rightBubbleImageView.image = rightImage;
    [self.contentView addSubview:rightBubbleImageView];
    
    rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    rightLabel.numberOfLines = 0;
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightBubbleImageView addSubview:rightLabel];
    eView = [[EmoticonView alloc] init];
    
}
-(void)config:(NSDictionary *)dic
{
    for (UIView *view in rightBubbleImageView.subviews) {
        if (view.tag == 9876) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in leftBubbleImageView.subviews) {
        if (view.tag == 9876) {
            [view removeFromSuperview];
        }
    }
    //计算文字大小
    //[[UIDevice currentDevice]systemVersion].floatValue  获取系统版本
    timeLabel.text = [UserInfoManager GetFormatDateByInterval:[dic[@"time"] intValue]];
    NSString * str = dic[@"text"];
    UIView *txView   =[eView viewWithText:str andFrame:CGRectMake(0, 0, 200, 1000) FontSize:14];
    txView.tag = 9876;
    CGSize size = CGSizeMake(CGRectGetWidth(txView.frame), CGRectGetHeight(txView.frame));
    
    //获取是对方还是自己
    if ([dic[@"flag"] intValue] ==1) {
        //自己
        
        leftBubbleImageView.hidden = YES;
        leftHeaderImageView.hidden = YES;
        
        rightBubbleImageView.hidden = NO;
        rightHeaderImageView.hidden = NO;
        [rightHeaderImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
        
        //设置Frame

        rightBubbleImageView.frame = CGRectMake(self.contentView.frame.size.width-eView.www - 30-70, 45, eView.www+35, size.height+20);
        [rightBubbleImageView addSubview:txView];
//        rightLabel.frame = CGRectMake(10, 5, size.width + 10, size.height + 10);
//        rightLabel.text = str;
        
    }else if([dic[@"flag"] intValue] ==0){
        //对方
        leftHeaderImageView.hidden = NO;
        leftBubbleImageView.hidden = NO;
        [leftHeaderImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"35"]];
        
        rightBubbleImageView.hidden = YES;
        rightHeaderImageView.hidden = YES;
        
        leftBubbleImageView.frame = CGRectMake(70, 45, eView.www+35, size.height+20);
        [leftBubbleImageView addSubview:txView];
//        leftLabel.frame = CGRectMake(15, 5, size.width+ 10, size.height + 10);
//        leftLabel.text = str;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
