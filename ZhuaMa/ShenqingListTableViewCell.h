//
//  ShenqingListTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShenqingListViewController.h"
@protocol SelectRowDelegate <NSObject>

-(void)selectRow:(int)row;

@end

@interface ShenqingListTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *jueseLabel;
}
@property(nonatomic)ShenqingListViewController<SelectRowDelegate>*delegate;
@property(nonatomic)int row;
-(void)config:(NSDictionary *)dic;
@end
