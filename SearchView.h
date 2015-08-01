//
//  SearchView.h
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "CityView.h"
#import "CityDetailView.h"
#import "TypeView.h"
#import "OrderView.h"
@class SearchView;

@protocol SearchDelegate <NSObject>

-(void)search:(SearchView *)searchView Dic:(NSDictionary *)dic Flag:(int)flag;

@end

@interface SearchView : BaseADView<CitySelectDelegate,CityDetailSelectDelegate,TypeSelectDelegate,OrderSelectDelegate>
{
    UIView *rightBgView;
    UITextField *textField;
    NSString *pro;
    NSString *proID;
    NSString *city;
    NSString *cityID;
}
@property(nonatomic,strong)id<SearchDelegate>delegate;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end
