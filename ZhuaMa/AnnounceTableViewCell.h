//
//  AnnounceTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnounceTableViewCell : UITableViewCell
{
    UIImageView *headImageView;
    UILabel *titleLabel ;
    UILabel *distance;
    UILabel *timeLabel;
    UILabel *xinZiLabel;
    UILabel *shenqingCount;
    UILabel *timeEnd;
    UILabel *leftTime;
    UILabel *typeLabel;
    UILabel *xinziTishi;
    UILabel *payType;
    UILabel *raiseGuimo;
}
-(void)config:(NSDictionary *)dic;
@end
