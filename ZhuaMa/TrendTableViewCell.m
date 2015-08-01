//
//  TrendTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/25.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "TrendTableViewCell.h"
#import "RenmaiDetailViewController.h"
#import "EmoticonView.h"
@implementation TrendTableViewCell
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
    line.tag = 345;
    [self.contentView addSubview:line];
    headView = [MyControll createButtonWithFrame:CGRectMake(10, 10, 35, 35) bgImageName:nil imageName:@"90" title:nil selector:@selector(btnClick:) target:self];
    headView.titleLabel.textAlignment = NSTextAlignmentLeft;
    headView.layer.cornerRadius = 3;
    headView.clipsToBounds = YES;
    headView.tag = 100;
    [self.contentView addSubview:headView];
    
    name = [MyControll createButtonWithFrame:CGRectMake(55, 10, 60, 20) bgImageName:nil imageName:nil title:@"张仃" selector:@selector(btnClick:) target:self];
    [name setTitleColor:[UIColor colorWithRed:169.0/256 green:179.0/256 blue:202.0/256 alpha:1] forState:UIControlStateNormal];
    name.titleLabel.font = [UIFont systemFontOfSize:15];
    name.tag = 101;
    [self.contentView addSubview:name];
    
    shenfen = [MyControll createLabelWithFrame:CGRectMake(115, 10, self.contentView.frame.size.width - 10 - 115, 20) title:@"/专业演员" font:14];
    shenfen.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:shenfen];
    
//    content = [MyControll createLabelWithFrame:CGRectMake(55, 40, self.contentView.frame.size.width - 55 - 10, 40) title:nil font:15];
//    [self.contentView addSubview:content];
    
    imageSC = [[UIScrollView alloc]initWithFrame:CGRectMake(55, 80, self.contentView.frame.size.width - 55 - 10, 60)];
    imageSC.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:imageSC];
    
    bottomView = [MyControll createViewWithFrame:CGRectMake(0, 150, self.contentView.frame.size.width, 30)];
    [self.contentView addSubview:bottomView];
    
    time = [MyControll createLabelWithFrame:CGRectMake(55, 0, 60, 30) title:@"今天12:00" font:13];
    time.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:time];
    
    zanBtn = [MyControll createButtonWithFrame:CGRectMake(130, 0, 20, 30) bgImageName:nil imageName:@"31" title:nil selector:@selector(btnClick:) target:self];
    zanBtn.tag = 102;
    [bottomView addSubview:zanBtn];
    zanCount = [MyControll createLabelWithFrame:CGRectMake(155, 0, 30, 30) title:@"12" font:13];
    zanCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:zanCount];
    
    shareBtn = [MyControll createButtonWithFrame:CGRectMake(185, 0, 20, 30) bgImageName:nil imageName:@"32" title:nil selector:@selector(btnClick:) target:self];
    [bottomView addSubview:shareBtn];
    shareBtn.tag = 103;
    shareCount = [MyControll createLabelWithFrame:CGRectMake(210, 0, 30, 30) title:@"23" font:13];
    shareCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:shareCount];
    
    commentBtn = [MyControll createButtonWithFrame:CGRectMake(240, 0, 20, 30) bgImageName:nil imageName:@"33" title:nil selector:@selector(btnClick:) target:self];
    commentBtn.tag = 104;
    [bottomView addSubview:commentBtn];
    
    commentCount = [MyControll createLabelWithFrame:CGRectMake(265, 0, 20, 30) title:@"0" font:13];
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
    else if (index == 3)
    {
        [_delegate share:_row];
    }
    else if (index == 2)
    {
        [_delegate zan:_row];
    }
    else if (index == 0||index == 1)
    {
        RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
        vc.uid = _tempDic[@"uid"];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
}
-(void)config:(NSDictionary *)dic
{
    for (UIView *view in self.contentView.subviews) {
        if (view.tag == 9876) {
            [view removeFromSuperview];
        }
    }

    if ([[dic[@"flag"] stringValue]isEqualToString:@"0"]) {
        [zanBtn setImage:[UIImage imageNamed:@"31"] forState:UIControlStateNormal];
    }
    else if ([[dic[@"flag"] stringValue]isEqualToString:@"1"])
    {
        [zanBtn setImage:[UIImage imageNamed:@"411"] forState:UIControlStateNormal];
    }
    _tempDic = [NSDictionary dictionaryWithDictionary:dic];
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] forState:UIControlStateNormal];
    [name setTitle:dic[@"name"] forState:UIControlStateNormal];
    zanCount.text = dic[@"znum"];
    shareCount.text = dic[@"snum"];
    commentCount.text = dic[@"cnum"];
    int time1 = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time1];
    NSString *str1 = [MyControll dayLabelForMessage:date];
    time.text = str1;
    shenfen.text = dic[@"type"];
    NSString *str = dic[@"text"];
//    CGSize size;
//    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
//        size = [str boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 55 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
//    }else{
//        size = [str sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 55 - 10, 1000)];
//    }
//    content.frame = CGRectMake(55, 40, self.contentView.frame.size.width - 55 - 10, size.height + 10);
//    content.text = str;
   
    UIView *txView   =[eView viewWithText:str andFrame:CGRectMake(55, 40, self.contentView.frame.size.width - 55 - 10, 1000) FontSize:15];
    txView.tag = 9876;
//    txView.backgroundColor = [UIColor redColor];
    [self.contentView  addSubview:txView];
    
//    CGSize size = CGSizeMake(CGRectGetWidth(txView.frame), CGRectGetHeight(txView.frame));
    
    
    
    NSArray *picArray = dic[@"image"];
    if (picArray.count == 0) {
        bottomView.frame = CGRectMake(0, 40 + txView.frame.size.height+5, self.contentView.frame.size.width, 30);
        imageSC.hidden = YES;
        for (UIView *v in imageSC.subviews) {
            [v removeFromSuperview];
        }
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
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:) ]];
            imageView.tag = 3000+i;
            [imageSC addSubview:imageView];
            width += 75;
        }
        imageSC.contentSize = CGSizeMake(width, 70);
        if (width<self.contentView.frame.size.width - 55 -10) {
            imageSC.frame = CGRectMake(55, 40+txView.frame.size.height+5, width, 70);
        }
        else{
            imageSC.frame = CGRectMake(55, 40 + txView.frame.size.height +5 , self.contentView.frame.size.width - 55 -10, 70);
        }
        bottomView.frame = CGRectMake(0,imageSC.frame.origin.y + imageSC.frame.size.height+10, self.contentView.frame.size.width, 30);
    }
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate picShow:_row page:sender.view.tag-3000];
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
