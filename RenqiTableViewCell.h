//
//  RenqiTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/29.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenqiTableViewCell : UITableViewCell
{
//    UIImageView*numImageView;
    UILabel *numLabel;
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *typeLabel;
    UIImageView *yingxiangliView;
    UILabel *yingxiangCount;
}
-(void)config:(NSDictionary *)dic;
@end
