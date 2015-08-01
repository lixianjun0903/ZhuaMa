//
//  RaiseStateView.h
//  ZhuaMa
//
//  Created by xll on 15/1/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
@protocol RaiseStateSelectDelegate <NSObject>

-(void)selectRaiseState:(NSString *)raiseState ID:(NSString *)id;

@end

@interface RaiseStateView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<RaiseStateSelectDelegate>delegate;
-(void)loadData;

@end
