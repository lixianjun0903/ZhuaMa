//
//  TonggaoTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TonggaoTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *xinjinLabel;
    
    UILabel *shenqingCount;
    UILabel *timeEndLabel;
    
    NSMutableDictionary *tempDic;
}
@property(nonatomic,strong)UIViewController *delegate;
-(void)config:(NSDictionary *)dic;
@end
