//
//  TTTSelectView.h
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "TypeView.h"
@class TTTSelectView;
@protocol TTTSelectViewDelegate <NSObject>

-(void)TTTSelect:(TTTSelectView *)TTTSelectView Dic:(NSDictionary *)dic Flag:(int)flag;

@end

@interface TTTSelectView : BaseADView<TypeSelectDelegate>
@property(nonatomic)id<TTTSelectViewDelegate>delegate;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
//@property(nonatomic)int typeNum;
-(void)StartGetData:(int)typeNum;

@end
