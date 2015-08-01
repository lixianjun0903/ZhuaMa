//
//  AnnounceTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "AnnounceTableViewCell.h"
#import "UserInfoManager.h"

@implementation AnnounceTableViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    headImageView = [MyControll createImageViewWithFrame:CGRectMake(10, 20, 60, 60) imageName:nil];
    [self.contentView addSubview:headImageView];
    
    titleLabel = [MyControll createLabelWithFrame:CGRectMake(80, 10, self.contentView.frame.size.width - 80-80, 20) title:nil font:15];
    [self.contentView addSubview:titleLabel];
    
    distance = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width-140, 10, 130, 20) title:nil font:12];
    distance.textAlignment =NSTextAlignmentRight;
    distance.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:distance];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(80, 50, self.contentView.frame.size.width-80-110, 20) title:nil font:13];
    [self.contentView addSubview:timeLabel];
    
    
    
    
    xinziTishi = [MyControll createLabelWithFrame:CGRectMake(80, 70, 50, 20) title:@"薪资：" font:13];
    xinziTishi.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:xinziTishi];
    
    
    payType = [MyControll createLabelWithFrame:CGRectMake(80, 70, 70, 20) title:@"付费方式：" font:13];
    payType.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:payType];
    payType.hidden = YES;
    
    raiseGuimo = [MyControll createLabelWithFrame:CGRectMake(80, 70, 70, 20) title:@"融资规模：" font:13];
    raiseGuimo.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:raiseGuimo];
    raiseGuimo.hidden = YES;
    
    
    xinZiLabel = [MyControll createLabelWithFrame:CGRectMake(120, 70, self.contentView.frame.size.width-120-10, 20) title:nil font:16];
    xinZiLabel.textAlignment = NSTextAlignmentLeft;
    xinZiLabel.textColor = [UIColor redColor];
    xinZiLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:xinZiLabel];
    
    UIView *bottomView = [MyControll createViewWithFrame:CGRectMake(0, 125, self.contentView.frame.size.width, 14)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.contentView addSubview:bottomView];
    
    UIImageView *bgView = [MyControll createImageViewWithFrame:CGRectMake(0, 100, self.contentView.frame.size.width, 30) imageName:@"t"];
    [self.contentView addSubview:bgView];
    
    shenqingCount = [MyControll createLabelWithFrame:CGRectMake(12, 5, 70, 20) title:nil font:13];
    [bgView addSubview:shenqingCount];
    
    timeEnd = [MyControll createLabelWithFrame:CGRectMake(82, 5, 150, 20) title:nil font:13];
    [bgView addSubview:timeEnd];
    
    leftTime = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width - 150, 5, 140, 20) title:nil font:13];
    leftTime.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:leftTime];
    
    typeLabel = [MyControll createLabelWithFrame:CGRectMake(80, 30, self.contentView.frame.size.width-80-10, 18) title:nil font:13];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:typeLabel];
    
    
}
-(void)config:(NSDictionary *)dic
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"90"]];
    titleLabel.text = dic[@"name"];
    if ([[dic[@"distance"] stringValue] isEqualToString:@"0"]) {
        distance.text = @"未知";
    }
    else
    {
        distance.text = [NSString stringWithFormat:@"距离:%.2fkm",(float)[dic[@"distance"] intValue]/1000];
    }
    if ([dic[@"subtype"]isEqualToString:@"1"]) {
         xinZiLabel.text = [NSString stringWithFormat:@"%@-%@元",dic[@"lmoney"],dic[@"hmoney"]];
            xinZiLabel.frame =CGRectMake(120, 70, self.contentView.frame.size.width-120-10, 20);
         xinziTishi.hidden = NO;
        xinziTishi.text = @"薪资：";
        payType.hidden = YES;
        raiseGuimo.hidden = YES;
        int time = [dic[@"time"] intValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *str = [MyControll dayLabelForMessage:date];
        timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
    }
   else if([dic[@"subtype"]isEqualToString:@"4"])
   {
       xinziTishi.hidden = YES;
       payType.hidden = NO;
       raiseGuimo.hidden = YES;
       NSArray *payArray = @[@"我请客",@"AA",@"你请客"];
       NSString *payStr = payArray[[dic[@"paytype"] intValue]-1];
       xinZiLabel.text = payStr;
        xinZiLabel.frame = CGRectMake(150, 70, self.contentView.frame.size.width-120-10, 20);
       int time = [dic[@"time"] intValue];
       NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
       NSString *str = [MyControll dayLabelForMessage:date];
       timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
       
   }
    else if([dic[@"subtype"]isEqualToString:@"5"])
    {
        xinZiLabel.text = [NSString stringWithFormat:@"%@万",dic[@"lmoney"]];
        xinZiLabel.frame = CGRectMake(150, 70, self.contentView.frame.size.width-120-10, 20);
        xinziTishi.hidden = YES;
        payType.hidden = YES;
        raiseGuimo.hidden = NO;
        
        NSArray *raiseStateArray = @[@"创意阶段",@"筹备阶段",@"拍摄阶段",@"后期制作阶段",@"发行阶段",@"DEMO阶段",@"测试阶段",@"已上线"];
        NSString *raiseStateStr = raiseStateArray[[dic[@"paytype"] intValue]-1];
        timeLabel.text = [NSString stringWithFormat:@"项目阶段：%@",raiseStateStr];
    }
    else
    {
        xinZiLabel.text = [NSString stringWithFormat:@"%@元",dic[@"lmoney"]];
        xinZiLabel.frame = CGRectMake(120, 70, self.contentView.frame.size.width-120-10, 20);
        xinziTishi.hidden = NO;
        xinziTishi.text = @"报价：";
        payType.hidden = YES;
        raiseGuimo.hidden = YES;
        int time = [dic[@"time"] intValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *str = [MyControll dayLabelForMessage:date];
        timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
    }
    shenqingCount.text = [NSString stringWithFormat:@"%@人申请",dic[@"num"]];
    
    int time1 = [dic[@"jtime"] intValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
    NSString *str1 = [MyControll dayLabelForMessage:date1];
    
    timeEnd.text = [NSString stringWithFormat:@"%@截止",str1];
    
    if (![[NSString stringWithFormat:@"%@",dic[@"ltime"]] isEqualToString:@"已经截止"]) {
        
        int hours = [dic[@"ltime"] intValue];
        int day = hours/24;
        int lhour = hours%24;
        if (day>0) {
            leftTime.text = [NSString stringWithFormat:@"剩余%d天",day];
        }
        else
        {
            leftTime.text = [NSString stringWithFormat:@"剩余%d小时",lhour];
        }
    }
    else{
        leftTime.text = [NSString stringWithFormat:@"%@",dic[@"ltime"]];
    }
    
    NSString *type = dic[@"type"];
    CGSize size = [MyControll getSize:type Font:13 Width:150 Height:20];
    typeLabel.frame = CGRectMake(80, 30, size.width + 5, 18);
    typeLabel.text = type;
    
    if ([dic[@"subtype"]isEqualToString:@"1"])
    {
         typeLabel.backgroundColor = [UIColor colorWithRed:0.33f green:0.83f blue:0.81f alpha:1.00f];
    }
    else if ([dic[@"subtype"]isEqualToString:@"2"])
    {
         typeLabel.backgroundColor = [UIColor colorWithRed:0.22f green:0.66f blue:1.00f alpha:1.00f];
    }
    else if ([dic[@"subtype"]isEqualToString:@"3"])
    {
         typeLabel.backgroundColor = [UIColor colorWithRed:0.95f green:0.36f blue:0.35f alpha:1.00f];
    }
    else if([dic[@"subtype"]isEqualToString:@"4"])
    {
         typeLabel.backgroundColor = [UIColor colorWithRed:0.81f green:0.47f blue:0.28f alpha:1.00f];
    }
    else if([dic[@"subtype"]isEqualToString:@"5"])
    {
        typeLabel.backgroundColor = [UIColor colorWithRed:0.85f green:0.36f blue:0.86f alpha:1.00f];
    }
   
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
