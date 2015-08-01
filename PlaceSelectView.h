//
//  PlaceSelectView.h
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "CityView.h"
#import "CityDetailView.h"



@class PlaceSelectView;

@protocol placeSelectDelegate <NSObject>

-(void)placeSelect:(PlaceSelectView *)placeSelectView Dic:(NSDictionary *)dic Flag:(int)flag;

@end

@interface PlaceSelectView : BaseADView<CitySelectDelegate,CityDetailSelectDelegate>
{
    NSString *pro;
    NSString *proID;
    NSString *city;
    NSString *cityID;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic)id<placeSelectDelegate>delegate;
@end
