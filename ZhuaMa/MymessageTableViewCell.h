//
//  MymessageTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MymessageTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UIImageView *addV;
    UILabel *typeLabel;
    UILabel *companyLabel;
    UILabel *timeLabel;
    UILabel *messageCount;
    
}
-(void)config:(NSDictionary *)dic;
@end
