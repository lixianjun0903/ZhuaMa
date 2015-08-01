//
//  SelectTabBar.m
//  TestRedCollar
//
//  Created by iHope on 14-1-23.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "SelectTabBar.h"

static SelectTabBar *gTabBar = nil;

@implementation SelectTabBar

@synthesize miIndex, delegate, OnForumTabSelect;

+ (SelectTabBar *)Share {
    return gTabBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gTabBar = self;
        self.userInteractionEnabled = YES;
//        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        NSArray *array = [NSArray arrayWithObjects:@"19", @"21", @"23", @"25", nil];
        NSArray *array1 = [NSArray arrayWithObjects:@"20", @"22", @"24", @"26", nil];
        int width = self.frame.size.width/array.count;
        int x = 0;
        for (int i = 0; i<array.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, (self.frame.size.height-44)/2, width, 44);
            button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            button.backgroundColor = self.backgroundColor;
            
            [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[array1 objectAtIndex:i]]  forState:UIControlStateSelected];
            [button addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.tag = i+1500;
            [self addSubview:button];
            x += width;
        }
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        lineView.image = [UIImage imageNamed:@"f_tableline"];
//        [self addSubview:lineView];
        
        [self RefreshView];
    }
    return self;
}

- (void)OnBtnClick:(UIButton *)sender {
    int index = (int)sender.tag-1500;
    if (delegate && [delegate respondsToSelector:@selector(CanSelectTab::)]) {
        if (![delegate CanSelectTab:self :index]) {
            return;
        }
    }
    self.miIndex = index;
 
    if (delegate && [delegate respondsToSelector:@selector(OnTabSelect:)]) {
        [delegate OnTabSelect:self];
    }
}

- (void)RefreshView {
    for (int i = 0; i < 5; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+1500];
        if (button) {
            button.selected = (i == miIndex);
        }
    }
}

- (void)setMiIndex:(int)index {
    miIndex = index;
    [self RefreshView];
}

@end
