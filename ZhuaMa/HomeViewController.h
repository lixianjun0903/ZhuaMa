//
//  HomeViewController.h
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "SelectTabBar.h"
#import "MyInfoViewController.h"
@interface HomeViewController : UITabBarController<SelectTabBarDelegate>
@property(nonatomic,strong)NSMutableArray *itemsArray;
@property(nonatomic,strong)MyInfoViewController *ctrl4;
@end
