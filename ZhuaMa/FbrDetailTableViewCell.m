//
//  FbrDetailTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "FbrDetailTableViewCell.h"

@implementation FbrDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    headImageView = [MyControll createImageViewWithFrame:CGRectMake(10, 40, 80, 80) imageName:nil];
    [self.contentView addSubview:headImageView];
    titleLabel = [MyControll createLabelWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20) title:nil font:16];
    [self.contentView addSubview:titleLabel];
    
    typeLabel = [MyControll createLabelWithFrame:CGRectMake(100, 40, self.contentView.frame.size.width - 100 - 10, 20) title:nil font:13];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = [UIColor whiteColor];
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(100, 60, self.contentView.frame.size.width - 100 - 10, 20) title:nil font:13];
    xinZiLabel = [MyControll createLabelWithFrame:CGRectMake(100, 80, self.contentView.frame.size.width-100 - 10, 20) title:nil font:13];
    placeLabel = [MyControll createLabelWithFrame:CGRectMake(100, 100, self.contentView.frame.size.width - 100 - 10,  20) title:nil font:13];
    
    [self.contentView addSubview:typeLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:xinZiLabel];
    [self.contentView addSubview:placeLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 139.5, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"90"]];
    titleLabel.text = dic[@"name"];
    
    
    int time = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *str = [MyControll dayLabelForMessage:date];
    timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
    
    if ([dic[@"subtype"] isEqualToString:@"1"]) {
        timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
        xinZiLabel.text = [NSString stringWithFormat:@"薪资：%@-%@元",dic[@"lmoney"],dic[@"hmoney"]];
    }
    else if ([dic[@"subtype"] isEqualToString:@"4"])
    {
        timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
        NSArray *payArray = @[@"我请客",@"AA",@"你请客"];
        NSString *payStr = payArray[[dic[@"paytype"] intValue]-1];
        xinZiLabel.text = [NSString stringWithFormat:@"付费方式：%@",payStr];
    }
    else if ([dic[@"subtype"] isEqualToString:@"5"])
    {
        NSArray *raiseStateArray = @[@"创意阶段",@"筹备阶段",@"拍摄阶段",@"后期制作阶段",@"发行阶段",@"DEMO阶段",@"测试阶段",@"已上线"];
        NSString *raiseStateStr = raiseStateArray[[dic[@"paytype"] intValue]-1];
        timeLabel.text = [NSString stringWithFormat:@"项目阶段：%@",raiseStateStr];
        xinZiLabel.text = [NSString stringWithFormat:@"融资规模：%@万",dic[@"lmoney"]];
    }
    else{
        timeLabel.text = [NSString stringWithFormat:@"时间：%@",str];
        xinZiLabel.text = [NSString stringWithFormat:@"报价：%@元",dic[@"lmoney"]];
    }
    placeLabel.text = [NSString stringWithFormat:@"详细地址：%@",dic[@"address"]];
    
    NSString *type = dic[@"type"];
    CGSize size = [MyControll getSize:type Font:13 Width:150 Height:20];
    typeLabel.frame = CGRectMake(100, 40, size.width + 5, 18);
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
