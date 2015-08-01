//
//  WorkInfoTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/19.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkInfoTableViewCell : UITableViewCell
{
    UILabel *companyName;
    UILabel *position;
    UILabel *timeLabel;
}
-(void)config:(NSDictionary *)dic;
@end
