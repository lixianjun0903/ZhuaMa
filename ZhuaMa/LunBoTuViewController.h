//
//  LunBoTuViewController.h
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"

@interface LunBoTuViewController : BaseADViewController
{
    UIScrollView *mainSC;
}
-(void)picShow:(NSArray *)dataArray atIndex:(int)page;
@end
