//
//  TrendTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 14/12/25.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendViewController.h"
#import "EmoticonView.h"
@protocol commentDelegate <NSObject>
-(void)comment:(int)row;
-(void)zan:(int)row;
-(void)share:(int)row;
-(void)picShow:(int)row page:(int)page;
@end

@interface TrendTableViewCell : UITableViewCell
{
    UIButton *headView;
    UIButton *name;
    UILabel *shenfen;
//    UILabel *content;
   
    UILabel *time;
    UIButton *zanBtn;
    UILabel *zanCount;
    UIButton *shareBtn;
    UILabel *shareCount;
    UIButton *commentBtn;
    UILabel *commentCount;
    UIView *bottomView;
    EmoticonView *eView;
}
@property(nonatomic)UIViewController<commentDelegate> *delegate;
@property (nonatomic,strong) UIScrollView *imageSC;
@property (nonatomic)int row;

@property (nonatomic,strong)NSDictionary *tempDic;

-(void)config:(NSDictionary *)dic;
//+(CGFloat)contentViewHeight:()
@end
