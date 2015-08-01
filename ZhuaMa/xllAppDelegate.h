//
//  xllAppDelegate.h
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "NavRootViewController.h"
#import "ImageDownManager.h"
//#import "LocationHandler.h"
@interface xllAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIImageView *mLoadView;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)HomeViewController *homeVC;
@property(nonatomic,strong)NavRootViewController *loginNav;
@property(nonatomic,strong)ImageDownManager *mDownManager;

@end
