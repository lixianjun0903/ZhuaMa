//
//  BaoliaoTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/26.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "BaoliaoTableViewCell.h"

@implementation BaoliaoTableViewCell
@synthesize imageSC;
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
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    [self.contentView addSubview:line];
    
//    content = [MyControll createLabelWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width - 20, 80) title:nil font:15];
//    [self.contentView addSubview:content];
    imageSC = [[UIScrollView alloc]initWithFrame:CGRectMake(55, 90, self.contentView.frame.size.width - 55 - 10, 70)];
    imageSC.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:imageSC];
    
    bottomView = [MyControll createViewWithFrame:CGRectMake(0, 160, self.contentView.frame.size.width, 30)];
    [self.contentView addSubview:bottomView];
    
    name = [MyControll createLabelWithFrame:CGRectMake(20, 0, 60, 30) title:@"匿名发布" font:13];
    name.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:name];
    
    zanBtn = [MyControll createButtonWithFrame:CGRectMake(140, 0, 20, 30) bgImageName:nil imageName:@"31" title:nil selector:@selector(btnClick:) target:self];
    zanBtn.tag = 102;
    [bottomView addSubview:zanBtn];
    zanCount = [MyControll createLabelWithFrame:CGRectMake(165, 0, 30, 30) title:@"12" font:13];
    zanCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:zanCount];
    
    shareBtn = [MyControll createButtonWithFrame:CGRectMake(195, 0, 20, 30) bgImageName:nil imageName:@"32" title:nil selector:@selector(btnClick:) target:self];
    [bottomView addSubview:shareBtn];
    shareBtn.tag = 103;
    shareCount = [MyControll createLabelWithFrame:CGRectMake(220, 0, 30, 30) title:@"23" font:13];
    shareCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:shareCount];
    
    commentBtn = [MyControll createButtonWithFrame:CGRectMake(250, 0, 20, 30) bgImageName:nil imageName:@"33" title:nil selector:@selector(btnClick:) target:self];
    commentBtn.tag = 104;
    [bottomView addSubview:commentBtn];
    
    commentCount = [MyControll createLabelWithFrame:CGRectMake(275, 0, 20, 30) title:@"0" font:13];
    commentCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:commentCount];
    
    eView = [[EmoticonView alloc] init];
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    if (index == 4) {
        [_delegate comment:_row];
    }
    else if (index == 2)
    {
        [_delegate zan:_row];
    }
    else if (index == 3)
    {
        [_delegate share:_row];
    }
}
-(void)config:(NSDictionary *)dic
{
    for (UIView *view in self.contentView.subviews) {
        if (view.tag == 9876) {
            [view removeFromSuperview];
        }
    }
//
    if ([[dic[@"flag"] stringValue]isEqualToString:@"0"]) {
        [zanBtn setImage:[UIImage imageNamed:@"31"] forState:UIControlStateNormal];
    }
    else if ([[dic[@"flag"] stringValue]isEqualToString:@"1"])
    {
        [zanBtn setImage:[UIImage imageNamed:@"411"] forState:UIControlStateNormal];
    }
    NSString *str = dic[@"text"];
    zanCount.text = dic[@"anum"];
    shareCount.text = dic[@"snum"];
    commentCount.text = dic[@"cnum"];
    if ([dic[@"name"] isEqualToString:@""]) {
        name.text = @"匿名发布";
    }
    else
    {
        name.text = dic[@"name"];
    }
//    CGSize size = [self getSize:str];
//    content.frame = CGRectMake(15, 10, self.contentView.frame.size.width - 25, size.height + 5);
//    content.text = str;
    
    txView   =[eView viewWithText:str andFrame:CGRectMake(15, 10, self.contentView.frame.size.width - 25, 1000) FontSize:15];
    txView.tag = 9876;
    [self.contentView  addSubview:txView];
    CGSize size = CGSizeMake(CGRectGetWidth(txView.frame), CGRectGetHeight(txView.frame));
    
    
    NSArray *picArray = dic[@"image"];
    if (picArray.count == 0) {
        imageSC.hidden = YES;
        for (UIView *v in imageSC.subviews) {
            [v removeFromSuperview];
        }
        bottomView.frame = CGRectMake(0,10 + size.height+15, self.contentView.frame.size.width, 30);
    }
    else
    {
        imageSC.hidden = NO;
        for (UIView *v in imageSC.subviews) {
            [v removeFromSuperview];
        }
        float width  = 5;
        for (int i = 0; i<picArray.count; i++) {
            UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(width, 0, 70, 70) imageName:nil];
            imageView.tag = 3000+i;
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:) ]];
            [imageSC addSubview:imageView];
            width += 75;
        }
        imageSC.contentSize = CGSizeMake(width, 70);
        if (width<self.contentView.frame.size.width - 55 -10) {
            imageSC.frame = CGRectMake(55, 10 + txView.frame.size.height +10 , width, 70);
        }
        else
        {
            imageSC.frame = CGRectMake(55, 10 + txView.frame.size.height +10 , self.contentView.frame.size.width - 55 -10, 70);
        }
        bottomView.frame = CGRectMake(0,imageSC.frame.origin.y + imageSC.frame.size.height+10, self.contentView.frame.size.width, 30);
    }
}
- (void)awakeFromNib
{
    // Initialization code
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate picShow:_row page:sender.view.tag-3000];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
