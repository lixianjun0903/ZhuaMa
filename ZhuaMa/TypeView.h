//
//  TypeView.h
//  ZhuaMa
//
//  Created by xll on 15/1/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol TypeSelectDelegate <NSObject>

-(void)selectType:(NSString *)type ID:(NSString *)id;

@end

@interface TypeView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<TypeSelectDelegate>delegate;
-(void)loadData:(int)num;
@end
