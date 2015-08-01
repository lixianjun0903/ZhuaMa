//
//  EduInfoTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EduInfoTableViewCell : UITableViewCell
{
    UILabel *companyName;
    UILabel *position;
    UILabel *timeLabel;
    UILabel *xueli;
}
-(void)config:(NSDictionary *)dic;
@end
