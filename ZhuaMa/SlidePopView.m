
//
//  SlidePopView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SlidePopView.h"

@implementation SlidePopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        id target = [self initWithNibName:nil bundle:nil];
        if (target) {
            
        }
        [self viewDidLoad];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self;
}

- (void)viewDidLoad
{

}

- (UIView *)view {
    return self;
}

- (UINavigationController *)navigationController {
    NSLog(@"%@, %@", self.mRootCtrl.navigationController, self.mRootCtrl);
    return self.mRootCtrl.navigationController;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    
}

@end
