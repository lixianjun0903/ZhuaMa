//
//  SlidePopViewController.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SlidePopViewController.h"

@interface SlidePopViewController () {
    int miOffset;
    UIView *mCoverView;
    UIScrollView *mBackView;
    CGPoint mStartPos;
}

@end

@implementation SlidePopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)LoadContent {
    miOffset = self.view.frame.size.width*0.85;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowLeftView) name:kMsg_SlideLeft object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowRightView) name:kMsg_SlideRight object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowMainView) name:kMsg_SlideCenter object:nil];
    
    mBackView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mBackView.scrollEnabled = NO;
    mBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mBackView.contentSize = CGSizeMake(self.view.frame.size.width+miOffset*2, self.view.frame.size.height);
    [self.view addSubview:mBackView];
    
    [self AddLeftView];
    [self AddRightView];
    [self AddCenterView];
    
    mCoverView = [[UIView alloc] initWithFrame:CGRectMake(miOffset, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mCoverView.hidden = YES;
    [mBackView addSubview:mCoverView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [mCoverView addGestureRecognizer:pan];
    [mCoverView addGestureRecognizer:tap];
    
    self.view.hidden = YES;
    mBackView.contentOffset = CGPointMake(miOffset, 0);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    mBackView.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
    
    [self performSelector:@selector(ShowMainView2) withObject:nil afterDelay:0.1];
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            mStartPos = mBackView.contentOffset;
        case UIGestureRecognizerStateChanged:{
            
            CGPoint point = [sender translationInView:mBackView];
            mBackView.contentOffset = CGPointMake(mStartPos.x-point.x, 0);
            NSLog(@"UIGestureRecognizerStateChanged:%f,%f",point.x,point.y);
 
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGPoint point = [sender velocityInView:mBackView];
            
            int iOffset = mBackView.contentOffset.x;
            NSLog(@"UIGestureRecognizerStateEnded:%f,%f, %d",point.x,point.y, iOffset);
            if (iOffset < miOffset*0.3) {
                [self ShowLeftView];
            }
            else if (iOffset > self.view.frame.size.width+miOffset*0.3) {
                [self ShowRightView];
            }
            else {
                [self ShowMainView];
            }
            break;
        }
        default:
            break;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"tapGesture:%d", sender.state);
    
    [self ShowMainView];
}

- (void)handlePan:(UIPanGestureRecognizer *)rec {
    NSLog(@"xxoo---xxoo---xxoo");
    CGPoint point = [rec translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    float fOffset = -point.x;
    mBackView.contentOffset = CGPointMake(fOffset, 0);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ShowMainView2 {
    mCoverView.hidden = YES;
    self.view.hidden = NO;
    mBackView.contentOffset = CGPointMake(miOffset, 0);
}

- (void)ShowMainView {
    mCoverView.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    mBackView.contentOffset = CGPointMake(miOffset, 0);
    [UIView commitAnimations];
}

- (void)ShowLeftView {
    mCoverView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    mBackView.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}

- (void)ShowRightView {
    mCoverView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    mBackView.contentOffset = CGPointMake(miOffset*2, 0);
    [UIView commitAnimations];
}

- (void)AddLeftView {
    if (self.mLeftCtrl) {
        CGRect rect = CGRectMake(0, 0, miOffset, self.view.frame.size.height);
        UIView *leftView = self.mLeftCtrl.view;
        leftView.frame = rect;
        if (leftView) {
            leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [mBackView addSubview:leftView];
            [mBackView sendSubviewToBack:leftView];
            NSLog(@"AddLeftView");
        }
    }
}

- (void)AddRightView {
    if (self.mRightCtrl) {
        CGRect rect = CGRectMake(self.view.frame.size.width+miOffset, 0, miOffset, self.view.frame.size.height);
        UIView *rightView = self.mRightCtrl.view;
        rightView.frame = rect;
        if (rightView) {
            rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [mBackView addSubview:rightView];
            [mBackView sendSubviewToBack:rightView];
            NSLog(@"AddRightView");
        }
    }
}

- (void)AddCenterView {
    if (self.mMainCtrl) {
        int iTop = IOS_7?20:0;
        CGRect rect = CGRectMake(miOffset, iTop, self.view.frame.size.width, self.view.frame.size.height-iTop);
        UIView *mainView = self.mMainCtrl.view;
        mainView.frame = rect;
        if (mainView) {
            mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [mBackView addSubview:mainView];
            [mBackView sendSubviewToBack:mainView];
            NSLog(@"AddCenterView");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mLeftCtrl viewWillAppear:animated];
    self.mRightCtrl.navigationController.navigationBarHidden = YES;
    self.mLeftCtrl.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mRightCtrl.navigationController.navigationBarHidden = NO;
    self.mLeftCtrl.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
