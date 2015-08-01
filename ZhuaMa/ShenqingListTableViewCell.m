//
//  ShenqingListTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "ShenqingListTableViewCell.h"

@implementation ShenqingListTableViewCell

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
    UIView *topline = [MyControll createViewWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.5)];
    topline.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.00f];
    [self.contentView addSubview:topline];
    
    headView = [MyControll createImageViewWithFrame:CGRectMake(10, 15, 55, 55) imageName:nil];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(75, 15, self.contentView.frame.size.width - 75-10, 25) title:nil font:18];
    [self.contentView addSubview:nameLabel];
    
    jueseLabel = [MyControll createLabelWithFrame:CGRectMake(75, 40, self.contentView.frame.size.width-75-10, 20) title:nil font:14];
    jueseLabel.textColor=[UIColor colorWithRed:0.43f green:0.43f blue:0.43f alpha:1.00f];
    [self.contentView addSubview:jueseLabel];
    
    UIView *bottomline = [MyControll createViewWithFrame:CGRectMake(0, 85-0.5, self.contentView.frame.size.width, 0.5)];
    bottomline.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.00f];
    [self.contentView addSubview:bottomline];
    
}
-(void)config:(NSDictionary *)dic
{
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    nameLabel.text = dic[@"name"];
    jueseLabel.text = dic[@"type"];
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
