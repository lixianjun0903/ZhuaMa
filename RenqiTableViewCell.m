//
//  RenqiTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/29.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RenqiTableViewCell.h"

@implementation RenqiTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    numLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, 20, 20) title:nil font:12];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment =NSTextAlignmentCenter;
    numLabel.layer.cornerRadius = 1;
    numLabel.clipsToBounds = YES;
    [self.contentView addSubview:numLabel];
    
    headView = [MyControll createImageViewWithFrame:CGRectMake(55, 15, 60, 60) imageName:nil];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(130, 20, 100, 25) title:nil font:18];
    [self.contentView addSubview:nameLabel];
    
    typeLabel = [MyControll createLabelWithFrame:CGRectMake(130, 50, 100, 20) title:nil font:13];
    typeLabel.textColor = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
    [self.contentView addSubview:typeLabel];
    
    yingxiangliView = [MyControll createImageViewWithFrame:CGRectMake(self.contentView.frame.size.width-80, 25, 30, 25) imageName:@"n6@2x"];
    yingxiangliView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:yingxiangliView];
    
    yingxiangCount = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width-90, 48, 50, 20) title:nil font:12];
    yingxiangCount.textAlignment = NSTextAlignmentCenter;
    yingxiangCount.textColor = [UIColor colorWithRed:0.99f green:0.65f blue:0.36f alpha:1.00f];
    [self.contentView addSubview:yingxiangCount];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 89.5, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    numLabel.text = [NSString stringWithFormat:@"%@",dic[@"num"]];
    if ([dic[@"num"] intValue]<=3) {
        numLabel.backgroundColor = [UIColor colorWithRed:0.98f green:0.60f blue:0.24f alpha:1.00f];
    }
    else{
        numLabel.backgroundColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.00f];
    }
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    nameLabel.text = dic[@"name"];
    typeLabel.text = dic[@"type"];
    yingxiangCount.text = dic[@"source"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
