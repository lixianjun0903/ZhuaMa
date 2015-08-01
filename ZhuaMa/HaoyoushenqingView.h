//
//  HaoyoushenqingView.h
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "MJRefresh.h"
#import "HaoyouShenqingTableViewCell.h"
@interface HaoyoushenqingView : BaseADView<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    int mpage;
    int type;
    
    
    int rowNum;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)UIViewController *delegate;

@end
