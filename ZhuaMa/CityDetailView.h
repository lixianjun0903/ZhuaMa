//
//  CityDetailView.h
//  ZhuaMa
//
//  Created by xll on 15/1/7.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol CityDetailSelectDelegate <NSObject>

-(void)selectCityDetail:(NSString *)city ID:(NSString *)id;

@end


@interface CityDetailView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<CityDetailSelectDelegate>delegate;
-(void)loadData:(NSString *)str;
@end
