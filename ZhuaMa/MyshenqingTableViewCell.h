//
//  MyshenqingTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyshenqingTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *xinjinLabel;
    
}
-(void)config:(NSDictionary *)dic;
@end
