//
//  MessageView.h
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "MymessageTableViewCell.h"
#import "MJRefresh.h"
@interface MessageView : BaseADView<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    int mpage;
    int type;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)UIViewController *delegate;
@end
