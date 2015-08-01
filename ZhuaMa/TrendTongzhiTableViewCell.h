//
//  TrendTongzhiTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendTongzhiTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *content;
    UILabel *timeLabel;
}
-(void)config:(NSDictionary *)dic;
@end
