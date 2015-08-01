//
//  ProjectTypeSelect.h
//  ZhuaMa
//
//  Created by xll on 15/1/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"


@protocol ProjectTypeSelectDelegate <NSObject>

-(void)selectProType:(NSString *)projectType ID:(NSString *)id;

@end


@interface ProjectTypeSelectView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<ProjectTypeSelectDelegate>delegate;
-(void)loadData;

@end
