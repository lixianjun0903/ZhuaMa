//
//  RenmaiTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/29.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenmaiTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *typeLabel;
    UIImageView *flagImageView;
}
-(void)config:(NSDictionary *)dic type:(int)flag;
@end
