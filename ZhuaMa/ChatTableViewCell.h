//
//  ChatTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmoticonView.h"
@interface ChatTableViewCell : UITableViewCell
{
    //左边
    UIImageView * leftHeaderImageView;
    UIImageView * leftBubbleImageView;
    UILabel * leftLabel;
    
    //右边
    UIImageView * rightHeaderImageView;
    UIImageView * rightBubbleImageView;
    UILabel * rightLabel;
    UILabel *timeLabel;
    EmoticonView *eView;

}
-(void)config:(NSDictionary *)dic;

@end
