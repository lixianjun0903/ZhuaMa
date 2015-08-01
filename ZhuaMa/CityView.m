//
//  CityView.m
//  ZhuaMa
//
//  Created by xll on 15/1/7.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "CityView.h"
#import "pinyin.h"
#import "CityDetailView.h"
@implementation CityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc
{
    self.mDownManager.delegate = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.delegate = self;
        _tableView.backgroundColor= [UIColor colorWithRed:0.87f green:0.87f blue:0.86f alpha:1.00f];
        _tableView.dataSource = self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@citylist?pid=0",SERVER_URL];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        NSLog(@"%@", array);
        [self letterArray:array];
        [_tableView reloadData];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    NSArray *array = [self.mDict objectForKey:key];
    return array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.mDict.count;
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.titleArray;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSArray *keys = [self GetSortKeys:self.mDict];
//    NSString *key = [keys objectAtIndex:section];
//    return key;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
//    cell.textLabel.text = array[indexPath.row][@"value"];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
        }
    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(0, 0, vWIDTH, 40) title:array[indexPath.row][@"value"] font:15];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    cell.backgroundColor =[UIColor colorWithRed:0.87f green:0.87f blue:0.86f alpha:1.00f];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
   
    [_delegate selectCity:dict[@"value"] ID:dict[@"id"]];
}
-(void)letterArray:(NSArray *)array
{
    
    NSMutableDictionary *letterDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *letterArray = [NSMutableArray arrayWithCapacity:26];
    for (NSDictionary *dic in array) {
        NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"value"]]];
        if (letterArray == nil) {
            [letterArray addObject:letter];
        }
        else
        {
            int count = 0;
            for (NSString *str in letterArray) {
                if (![str isEqualToString:letter]) {
                    count ++;
                }
            }
            if (count == letterArray.count) {
                [letterArray addObject:letter];
            }
        }
    }
    self.titleArray = [self sort:letterArray];
    for (NSString *str in letterArray) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"value"]]];
            if ([letter isEqualToString:str]) {
                [tempArray addObject:dic];
            }
        }
        [letterDic setObject:tempArray forKey:str];
    }
    self.mDict = [NSMutableDictionary dictionaryWithDictionary:letterDic];
    
//    NSString *name = [NSString stringWithFormat:@"sheng.plist"];
//    NSString *path = [[NSBundle mainBundle] resourcePath];
//    path = [path stringByAppendingPathComponent:name];
//
////    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:path]];
//    
//    [[self.mDict allKeys] writeToFile:path atomically:YES];

}

-(NSMutableArray *)sort:(NSMutableArray *)marr
{
    for(int i = 0; i < marr.count - 1; i++)
    {
        for( int j = 0 ; j < marr.count - 1 - i; j++ )
        {
            int prev = j;
            int next = j + 1;
            NSString * str_prev = marr[prev];
            NSString * str_next = marr[next];
            if([str_prev compare:str_next] == NSOrderedDescending)
            {
                [marr exchangeObjectAtIndex:prev withObjectAtIndex:next];
            }
        }
    }
    return marr;
}
- (NSArray *)GetSortKeys:(NSDictionary *)dict {
    return [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
}
@end
