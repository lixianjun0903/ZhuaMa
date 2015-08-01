//
//  recentFabuView.h
//  ZhuaMa
//
//  Created by xll on 15/1/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol RecentSelectDelegate <NSObject>

-(void)selectRecent:(NSString *)word ID:(NSString *)id;

@end

@interface RecentFabuView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}

@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<RecentSelectDelegate>delegate;
-(void)loadData;

@end
