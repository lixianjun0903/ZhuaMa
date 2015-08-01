//
//  EduInfoTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "EduInfoTableViewCell.h"

@implementation EduInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
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
    xueli  = [MyControll createLabelWithFrame:CGRectMake(20, 70, self.contentView.frame.size.width - 40, 20) title:nil font:14];
}
-(void)config:(NSDictionary *)dic
{
    companyName.text = dic[@"company"];
    position.text = [NSString stringWithFormat:@"院系/专业：%@",dic[@"post"]];
    timeLabel.text = [NSString stringWithFormat:@"在校时间：%@-%@",dic[@"stime"],dic[@"etime"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
