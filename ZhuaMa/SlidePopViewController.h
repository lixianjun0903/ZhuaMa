//
//  SlidePopViewController.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidePopView.h"

@interface SlidePopViewController : UIViewController {
    
}

@property (nonatomic, strong) SlidePopView *mLeftCtrl;
@property (nonatomic, strong) SlidePopView *mRightCtrl;
@property (nonatomic, strong) UIViewController *mMainCtrl;

- (void)LoadContent;
- (void)ShowRightView;


#define kMsg_SlideLeft  @"kMsg_SlideLeft"
#define kMsg_SlideRight  @"kMsg_SlideRight"
#define kMsg_SlideCenter  @"kMsg_SlideCenter"

@end
