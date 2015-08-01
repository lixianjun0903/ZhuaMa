//
//  TrendTongzhiTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TrendTongzhiTableViewCell.h"

@implementation TrendTongzhiTableViewCell

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
    headView = [MyControll createImageViewWithFrame:CGRectMake(10, 15, 50, 50) imageName:nil];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(70, 15, self.contentView.frame.size.width - 70 - 100, 20) title:nil font:16];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width - 100, 15, 85, 20) title:nil font:14];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
    content = [MyControll createLabelWithFrame:CGRectMake(70, 40, self.contentView.frame.size.width - 70 - 15, 20) title:nil font:15];
    content.textColor = [UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1.00f];
    [self.contentView addSubview:content];
    
    UIView *line = [MyControll createViewWithFrame:CGRectMake(0, 79.5, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor =[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.contentView addSubview:line];
    
}
-(void)config:(NSDictionary *)dic
{
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    nameLabel.text = dic[@"name"];
    
    
    int t = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *str1 = [MyControll dayLabelForMessage:date];
    
    
    timeLabel.text = str1;
    
//    timeLabel.text = dic[@"time"];
    content.text = dic[@"text"];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
