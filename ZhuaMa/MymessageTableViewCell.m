//
//  MymessageTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MymessageTableViewCell.h"

@implementation MymessageTableViewCell

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
    headView = [MyControll createImageViewWithFrame:CGRectMake(10, 15, 55, 55) imageName:nil];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(75, 15, 50, 25) title:nil font:18];
    [self.contentView addSubview:nameLabel];
    
    addV = [MyControll createImageViewWithFrame:CGRectMake(125, 15, 28, 24) imageName:@"v"];
    [self.contentView addSubview:addV];
    
    typeLabel = [MyControll createLabelWithFrame:CGRectMake(145, 15, self.contentView.frame.size.width - 145-80, 20) title:nil font:14];
    typeLabel.textColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.00f];
    [self.contentView addSubview:typeLabel];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width-80, 15, 70, 18) title:nil font:14];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
    companyLabel = [MyControll createLabelWithFrame:CGRectMake(75, 40, self.contentView.frame.size.width - 80 - 75, 20) title:nil font:14];
    [self.contentView addSubview:companyLabel];
    
    messageCount = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width - 40, 40, 30, 20) title:nil font:14];
    messageCount.backgroundColor = [UIColor colorWithRed:0.94f green:0.06f blue:0.13f alpha:1.00f];
    messageCount.textColor = [UIColor whiteColor];
    messageCount.clipsToBounds = YES;
    messageCount.layer.cornerRadius = 5;
    messageCount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:messageCount];
    
    UIView *line = [MyControll createViewWithFrame:CGRectMake(20, 84.5, self.contentView.frame.size.width - 20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    NSString *str = dic[@"name"];
    CGSize size  =  [MyControll getSize:str Font:18 Width:100 Height:25];
    nameLabel.frame = CGRectMake(75, 15, size.width +5, 25);
    nameLabel.text = str;
    
    if ([dic[@"flag"] isEqualToString:@"1"]) {
        addV.frame = CGRectMake(75+size.width +5, 15, 20, 25);
        addV.hidden = NO;
        typeLabel.text = dic[@"type"];
        typeLabel.frame = CGRectMake(75+size.width + 5+20, 15, self.contentView.frame.size.width - (75+size.width + 5+20) - 80, 20);
    }
    else
    {
        addV.hidden = YES;
        typeLabel.text = dic[@"type"];
        typeLabel.frame = CGRectMake(75+size.width + 5 + 2, 15, self.contentView.frame.size.width - (75+size.width + 5+20) - 80, 20);
        
    }
    
    companyLabel.text = dic[@"company"];
    messageCount.text = dic[@"count"];
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
