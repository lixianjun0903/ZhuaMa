//
//  MyshenqingTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MyshenqingTableViewCell.h"

@implementation MyshenqingTableViewCell

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
    self.contentView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    UIView *line = [MyControll createViewWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    [self.contentView addSubview:line];
    
    UIView *bgView = [MyControll createViewWithFrame:CGRectMake(0, 10, self.contentView.frame.size.width, 110)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    headView  = [MyControll createImageViewWithFrame:CGRectMake(10, 15, 70, 80) imageName:nil];
    [bgView addSubview:headView];
    
    titleLabel = [MyControll createLabelWithFrame:CGRectMake(90, 15, self.contentView.frame.size.width - 100, 20) title:nil font:16];
    [bgView addSubview:titleLabel];
    
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(90, 55, self.contentView.frame.size.width - 100, 20) title:nil font:14];
    [bgView addSubview:timeLabel];
    
    xinjinLabel= [MyControll createLabelWithFrame:CGRectMake(90, 75, self.contentView.frame.size.width - 100, 20) title:nil font:14];
    [bgView addSubview:xinjinLabel];
    
}
-(void)config:(NSDictionary *)dic
{

    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"90"]];

    titleLabel.text = dic[@"name"];
    
    timeLabel.text = [NSString stringWithFormat:@"时间：%@",dic[@"time"]];
    
    xinjinLabel.text = [NSString stringWithFormat:@"薪资：%@-%@",dic[@"lmoney"],dic[@"hmoney"]];
    
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
