//
//  MyInfoDetailViewController.h
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "BaseADViewController.h"

@interface MyInfoDetailViewController : BaseADViewController
@property(nonatomic,strong)NSMutableDictionary *infoDic;
-(void)refreshUI;
@end
