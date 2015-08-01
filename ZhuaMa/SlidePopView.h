//
//  SlidePopView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADView.h"

@interface SlidePopView : BaseADView {
    
}

@property (nonatomic, readonly) UIView *view;
@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, assign) UIViewController *mRootCtrl;

- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)viewDidLoad;

@end
