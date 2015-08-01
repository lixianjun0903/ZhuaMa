//
//  CommentTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

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
    UILabel *commentLable = [MyControll createLabelWithFrame:CGRectMake(20, 10, 40, 20) title:@"评分:" font:15];
    commentLable.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:commentLable];
    
    content = [MyControll createLabelWithFrame:CGRectMake(20, 30, self.contentView.frame.size.width - 40, 20) title:nil font:14];
    [self.contentView addSubview:content];
    
    nameLabel  =[MyControll createLabelWithFrame:CGRectMake(20, 30, 40, 20) title:nil font:14];
    nameLabel.textColor = [UIColor colorWithRed:0.49f green:0.56f blue:0.72f alpha:1.00f];
    [self.contentView addSubview:nameLabel];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(20, 40, self.contentView.frame.size.width-20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.contentView addSubview:line];
    
}
-(void)config:(NSDictionary *)dic
{
    for (UIImageView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    nameLabel.text = [NSString stringWithFormat:@"%@:",dic[@"name"]];
    CGSize size =  [MyControll getSize:dic[@"name"] Font:14 Width:140 Height:20];
    
    nameLabel.frame = CGRectMake(20, 32, size.width+20, 20);
    
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    for (int i= 0; i<50; i++) {
        CGSize tempSize =  [MyControll getSize:str Font:14 Width:140 Height:20];
        if (tempSize.width<size.width) {
           [str appendString:@" "];
        }
        
    }
    content.text = [NSString stringWithFormat:@"%@  %@",str,dic[@"text"]];
    CGSize sizeContent = [MyControll getSize:content.text Font:14 Width:self.contentView.frame.size.width-40 Height:300];
    
    content.frame = CGRectMake(20, 30, self.contentView.frame.size.width - 40, sizeContent.height +5);
    
    line.frame = CGRectMake(20, content.frame.origin.y+content.frame.size.height+5+10, self.contentView.frame.size.width-20, 0.5);
    
    for (int i = 0; i<5; i++) {
        if (i<[dic[@"star"] intValue]) {
            UIImageView *heartImage = [MyControll createImageViewWithFrame:CGRectMake(80+i*24, 10, 20, 20) imageName:@"81"];
            heartImage.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:heartImage];

        }
        else
        {
            UIImageView *heartImage = [MyControll createImageViewWithFrame:CGRectMake(80+i*24, 10, 20, 20) imageName:@"82"];
            heartImage.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:heartImage];

        }
        
    }
}
- (void)awakeFromNib
{
    // Initialization code
}
-(CGSize)getSize:(NSString *)str
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(100, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(100, 1000)];
    }
    return size;
}
-(CGSize)getSize1:(NSString *)str
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 40, 1000)];
    }
    return size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
