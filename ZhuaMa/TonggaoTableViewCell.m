//
//  TonggaoTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "TonggaoTableViewCell.h"
#import "ShenqingListViewController.h"
@implementation TonggaoTableViewCell

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
    UIView *line = [MyControll createViewWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    [self.contentView addSubview:line];
    
    headView  = [MyControll createImageViewWithFrame:CGRectMake(10, 15, 70, 80) imageName:nil];
    [self.contentView addSubview:headView];
    
    titleLabel = [MyControll createLabelWithFrame:CGRectMake(90, 15, self.contentView.frame.size.width - 100, 20) title:nil font:16];
    [self.contentView addSubview:titleLabel];
    
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(90, 55, self.contentView.frame.size.width - 100, 20) title:nil font:14];
    [self.contentView addSubview:timeLabel];
    
    xinjinLabel= [MyControll createLabelWithFrame:CGRectMake(90, 75, self.contentView.frame.size.width - 100, 20) title:nil font:14];
    [self.contentView addSubview:xinjinLabel];
    
    UIButton *canjiaBtn = [MyControll createButtonWithFrame:CGRectMake(self.contentView.frame.size.width-100, 50, 80, 30) bgImageName:nil imageName:@"canjiabaoming" title:nil selector:@selector(canjiaClick:) target:self];
    [self.contentView addSubview:canjiaBtn];

    UIView *bottomView = [MyControll createViewWithFrame:CGRectMake(0, 135, self.contentView.frame.size.width, 15)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.contentView addSubview:bottomView];
    
    UIImageView *bgView = [MyControll createImageViewWithFrame:CGRectMake(0, 105, self.contentView.frame.size.width, 35) imageName:@"t"];
    [self.contentView addSubview:bgView];
    
    shenqingCount = [MyControll createLabelWithFrame:CGRectMake(12, 5, 100, 20) title:nil font:14];
    [bgView addSubview:shenqingCount];
    
    timeEndLabel = [MyControll createLabelWithFrame:CGRectMake(self.contentView.frame.size.width-140, 5, 120, 20) title:nil font:14];
    timeEndLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:timeEndLabel];
    
}
-(void)canjiaClick:(UIButton *)sender
{
    ShenqingListViewController *vc = [[ShenqingListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = tempDic[@"id"];
    [_delegate.navigationController pushViewController: vc animated:YES];
}
-(void)config:(NSDictionary *)dic
{
    tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"90"]];
    
    titleLabel.text = dic[@"name"];
    
    timeLabel.text = [NSString stringWithFormat:@"时间：%@",dic[@"time"]];
    
    xinjinLabel.text = [NSString stringWithFormat:@"薪资：%@-%@",dic[@"lmoney"],dic[@"hmoney"]];
    
    shenqingCount.text = [NSString stringWithFormat:@"%@人申请",dic[@"num"]];
    
    timeEndLabel.text = [NSString stringWithFormat:@"%@ 截止",dic[@"time"]];
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
