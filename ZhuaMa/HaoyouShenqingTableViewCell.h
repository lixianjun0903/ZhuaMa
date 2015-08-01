//
//  HaoyouShenqingTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaoyouShenqingTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *typeLabel;
    
}
-(void)config:(NSDictionary *)dic;
@end
