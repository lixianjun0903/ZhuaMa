//
//  ChoseHYViewController.h
//  ZhuaMa
//
//  Created by xll on 15/1/6.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"

@protocol ChoseHYDeleagte <NSObject>

-(void)changeHY:(NSArray *)array;

@end
@interface ChoseHYViewController : BaseADViewController
@property(nonatomic,assign)id<ChoseHYDeleagte>delegate;
@property(nonatomic)int type;
@end
