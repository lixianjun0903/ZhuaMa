//
//  FbrDetailTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FbrDetailTableViewCell : UITableViewCell
{
    UIImageView *headImageView;
    UILabel *titleLabel ;
    UILabel *timeLabel;
    UILabel *xinZiLabel;
    UILabel *timeEnd;
    UILabel *placeLabel;
    UILabel *typeLabel;
//     UILabel *raiseGuimo;
}
-(void)config:(NSDictionary *)dic;
@end
