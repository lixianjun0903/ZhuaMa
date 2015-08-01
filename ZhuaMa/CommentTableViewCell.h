//
//  CommentTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *content;
    UIView *line;
}
-(void)config:(NSDictionary *)dic;
@end
