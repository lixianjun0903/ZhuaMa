//
//  HaoyouShenqingTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "HaoyouShenqingTableViewCell.h"

@implementation HaoyouShenqingTableViewCell
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
    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 10, 40, 40) imageName:nil];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(75, 15, 40,30) title:nil font:18];
    [self.contentView addSubview:nameLabel];
    
    typeLabel = [MyControll createLabelWithFrame:CGRectMake(115, 15, self.contentView.frame.size.width - 115-70, 30) title:nil font:14];
    typeLabel.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.68f alpha:1.00f];
    [self.contentView addSubview:typeLabel];
    
    UIView *line = [MyControll createViewWithFrame:CGRectMake(20, 59.5, self.contentView.frame.size.width - 20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.contentView addSubview:line];
    
    
}
-(void)config:(NSDictionary *)dic
{
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    CGSize size = [MyControll getSize:dic[@"name"] Font:18 Width:70 Height:30];
    nameLabel.frame = CGRectMake(75, 15, size.width +10, 30);
    nameLabel.text = dic[@"name"];
    
    typeLabel.frame = CGRectMake(75+size.width + 10, 15, self.contentView.frame.size.width - (75 + size.width + 10)-70, 30);
    typeLabel.text = dic[@"type"];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
