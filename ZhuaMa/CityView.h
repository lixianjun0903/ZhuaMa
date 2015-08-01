//
//  CityView.h
//  ZhuaMa
//
//  Created by xll on 15/1/7.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "ImageDownManager.h"

@protocol CitySelectDelegate <NSObject>

-(void)selectCity:(NSString *)city ID:(NSString *)id;
//-(void)passCity:(NSString *)city ID:(NSString *)id;

@end


@interface CityView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic)id<CitySelectDelegate>delegate;
-(void)loadData;

@end
