//
//  WorkInfoTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/19.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "WorkInfoTableViewCell.h"

@implementation WorkInfoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    companyName = [MyControll createLabelWithFrame:CGRectMake(20, 10, self.contentView.frame.size.width - 40, 20) title:nil font:15];
    [self.contentView addSubview:companyName];
    
    position = [MyControll createLabelWithFrame:CGRectMake(20, 30, self.contentView.frame.size.width-40, 20) title:nil font:14];
    [self.contentView addSubview:position];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 50, self.contentView.frame.size.width - 40, 20) title:nil font:14];
    [self.contentView addSubview:timeLabel];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    companyName.text = dic[@"company"];
    position.text = [NSString stringWithFormat:@"职位：%@",dic[@"post"]];
    timeLabel.text = [NSString stringWithFormat:@"工作时间：%@/%@",dic[@"stime"],dic[@"etime"]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
