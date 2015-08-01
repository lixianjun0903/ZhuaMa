//
//  SearchViewForTrend.h
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@class SearchViewForTrend;

@protocol SearchTrendDelegate <NSObject>

-(void)search:(SearchViewForTrend *)searchViewForTrend SearchStr:(NSString *)str Flag:(int)flag;

@end

@interface SearchViewForTrend : BaseADView
{
    UITextField *textField;
}
@property(nonatomic,strong)id<SearchTrendDelegate>delegate;
@end
