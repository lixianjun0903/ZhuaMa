//
//  OrderView.h
//  ZhuaMa
//
//  Created by xll on 15/1/27.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol OrderSelectDelegate <NSObject>

-(void)selectOrder:(NSString *)orderName ID:(NSString *)id;

@end


@interface OrderView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<OrderSelectDelegate>delegate;
-(void)loadData;
@end
