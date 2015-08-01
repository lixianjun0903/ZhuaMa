//
//  ZhiweiSelectView.h
//  ZhuaMa
//
//  Created by xll on 15/1/30.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"


@protocol ZhiweiSelectDelegate <NSObject>

-(void)selectZhiwei:(NSString *)zhiwei ID:(NSString *)id;

@end
@interface ZhiweiSelectView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<ZhiweiSelectDelegate>delegate;
-(void)loadData;

@end
