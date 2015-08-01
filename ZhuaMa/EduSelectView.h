//
//  EduSelectView.h
//  ZhuaMa
//
//  Created by xll on 15/2/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol EduSelectDelegate <NSObject>

-(void)selectEdu:(NSString *)edu ID:(NSString *)id;

@end


@interface EduSelectView : BaseADView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic)id<EduSelectDelegate>delegate;
-(void)loadData;



@end
