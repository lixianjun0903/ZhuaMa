//
//  SpecialtyViewController.h
//  ZhuaMa
//
//  Created by xll on 15/2/3.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"


@protocol ChoseSpecialtyDeleagte <NSObject>

-(void)changeSpecialty:(NSArray *)array;

@end

@interface SpecialtyViewController : BaseADViewController

@property(nonatomic,assign)id<ChoseSpecialtyDeleagte>delegate;
@end
