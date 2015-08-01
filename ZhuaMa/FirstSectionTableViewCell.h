//
//  FirstSectionTableViewCell.h
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstSectionTableViewCell : UITableViewCell<UIScrollViewDelegate>
{
    UIScrollView *topSC;
    UIPageControl *pageControll;
    UIImageView *imageView_left;
}
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)NSMutableArray *adArray;
@property(nonatomic,strong)UIViewController *delegate;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
-(void)getAdData:(BOOL)isReload;
-(void)loadData:(BOOL)isReload;
@end
