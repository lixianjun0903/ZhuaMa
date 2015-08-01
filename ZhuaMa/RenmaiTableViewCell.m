//
//  RenmaiTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "RenmaiTableViewCell.h"

@implementation RenmaiTableViewCell

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
    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 15, 50, 50) imageName:nil];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(90, 15, self.contentView.frame.size.width - 90 - 20, 25) title:nil font:18];
    [self.contentView addSubview:nameLabel];
    
    typeLabel = [MyControll createLabelWithFrame:CGRectMake(90, 40, self.contentView.frame.size.width - 90 - 20, 20) title:nil font:15];
    UIView *line = [MyControll createViewWithFrame:CGRectMake(0, 79.5, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
    [self.contentView addSubview:line];
    
    flagImageView = [MyControll createImageViewWithFrame:CGRectMake(self.contentView.frame.size.width - 48, 0, 48, 38) imageName:nil];
    [self.contentView addSubview:flagImageView];
}
-(void)config:(NSDictionary *)dic type:(int)flag
{
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    nameLabel.text = dic[@"name"];
    typeLabel.text = dic[@"type"];
    if (flag == 0 ) {
        flagImageView.image = [UIImage imageNamed:@"89"];
    }
    else if(flag == 1)
        
    {
        flagImageView.image = [UIImage imageNamed:@"erdu"];
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
