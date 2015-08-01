//
//  BaoliaoTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/26.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoliaoViewController.h"
#import "EmoticonView.h"
@protocol commentDelegate <NSObject>

-(void)comment:(int)row;
-(void)zan:(int)row;
-(void)share:(int)row;
-(void)picShow:(int)row page:(int)page;
@end

@interface BaoliaoTableViewCell : UITableViewCell
{
//    UILabel *content;
    UILabel *name;
    UIButton *zanBtn;
    UILabel *zanCount;
    UIButton *shareBtn;
    UILabel *shareCount;
    UIButton *commentBtn;
    UILabel *commentCount;
    UIView *bottomView;
    EmoticonView *eView;
    UIView *txView;
}
@property(nonatomic)UIViewController<commentDelegate> *delegate;
@property (nonatomic,strong) UIScrollView *imageSC;
@property (nonatomic)int row;
-(void)config:(NSDictionary *)dic;
@end
