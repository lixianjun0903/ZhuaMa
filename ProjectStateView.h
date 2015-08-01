//
//  ProjectStateView.h
//  ZhuaMa
//
//  Created by xll on 15/1/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol ProjectStateSelectDelegate <NSObject>

-(void)selectProState:(NSString *)projectType ID:(NSString *)id;

@end



@interface ProjectStateView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<ProjectStateSelectDelegate>delegate;
-(void)loadData;



@end
