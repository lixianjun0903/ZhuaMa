//
//  FirstSectionTableViewCell.m
//  ZhuaMa
//
//  Created by xll on 15/1/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "FirstSectionTableViewCell.h"
#import "RenQiViewController.h"
#import "NewActorViewController.h"
#import "HotViewController.h"
#import "GossipViewController.h"
#import "RenmaiDetailViewController.h"
#import "OfflineViewController.h"
#import "SkillSailViewController.h"
@implementation FirstSectionTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.contentView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    topSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, 130)];
    topSC.backgroundColor = [UIColor whiteColor];
    topSC.showsHorizontalScrollIndicator = NO;
    topSC.delegate = self;
    topSC.pagingEnabled = YES;
    [self.contentView addSubview:topSC];
    
    pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(vWIDTH/2+30, 90, vWIDTH/2-30, 40)];
    [self.contentView addSubview:pageControll];
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, vWIDTH, 100)];
    midView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:midView];
    
    NSArray *midImageArray = @[@"24@2x_12",@"24@2x_14",@"24@2x_16",@"24@2x_18"];
    NSArray *midLabelArray = @[@"人气榜",@"新人榜",@"热门榜",@"八卦榜"];
    for (int i=0; i<midImageArray.count; i++) {
        UIButton *midImageBtn = [MyControll createButtonWithFrame:CGRectMake(i*vWIDTH/4, 10, vWIDTH/4, 50) bgImageName:nil imageName:midImageArray[i] title:nil selector:@selector(midImageBtnClick:) target:self];
        midImageBtn.tag = 100+i;
        midImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [midView addSubview:midImageBtn];
        
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(i*vWIDTH/4, 65, vWIDTH/4, 20) title:midLabelArray[i] font:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        [midView addSubview:label];
    }
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 99.5, vWIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [midView addSubview:line];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 245, vWIDTH, 200)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    UIView *line_top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, 0.5)];
    line_top.backgroundColor =[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [bottomView addSubview:line_top];
    
    UIView *line_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 199.5, vWIDTH, 0.5)];
    line_bottom.backgroundColor =[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [bottomView addSubview:line_bottom];
    UIView *midLine = [[UIView alloc]initWithFrame:CGRectMake(vWIDTH/2, 3, 1, 194)];
    midLine.backgroundColor =[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [bottomView addSubview:midLine];
    UIView *midLine_heng = [[UIView alloc]initWithFrame:CGRectMake(vWIDTH/2+1, 99, vWIDTH/2-1, 1)];
    midLine_heng.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [bottomView addSubview:midLine_heng];
    
    imageView_left = [MyControll createImageViewWithFrame:CGRectMake(0, 200/3+1, vWIDTH/2, 200/3*2) imageName:@"26@2x_18"];
    imageView_left.contentMode= UIViewContentModeScaleAspectFit;
    [bottomView addSubview:imageView_left];
    UIImageView *meizhouyixing = [MyControll createImageViewWithFrame:CGRectMake(20, 200/3/4*3-5, 50, 25) imageName:@"29@2x_18"];
    meizhouyixing.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:meizhouyixing];
    
    UILabel *leftLabel = [MyControll createLabelWithFrame:CGRectMake(0, 15,vWIDTH/2, 30) title:@"Drama Queen" font:23];
    leftLabel.textAlignment =NSTextAlignmentCenter;
    [bottomView addSubview:leftLabel];
    
    
    
    UIImageView *right_top = [MyControll createImageViewWithFrame:CGRectMake(vWIDTH/2, 35, vWIDTH/4, 100-35) imageName:@"27@2x_18"];
    right_top.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:right_top];
    
    UILabel *rightLabel_top = [MyControll createLabelWithFrame:CGRectMake(vWIDTH-vWIDTH/4-10, 15, vWIDTH/4, 30) title:@"线下邀约" font:18];
    rightLabel_top.textColor = [UIColor colorWithRed:0.96f green:0.49f blue:0.00f alpha:1.00f];
    [bottomView addSubview:rightLabel_top];
    
    UILabel *timelabel= [MyControll createLabelWithFrame:CGRectMake(vWIDTH-vWIDTH/4-10, 45, vWIDTH/4, 20) title:@"时间顺序" font:13];
    timelabel.textColor = [UIColor colorWithRed:0.76f green:0.76f blue:0.76f alpha:1.00f];
    [bottomView addSubview:timelabel];
    
    UIImageView *right_bot = [MyControll createImageViewWithFrame:CGRectMake(vWIDTH-vWIDTH/4, 120, vWIDTH/4, 80) imageName:@"28@2x_18"];
    right_bot.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:right_bot];
    
    UILabel *rightLabel_bot = [MyControll createLabelWithFrame:CGRectMake(vWIDTH/2+10, 115, vWIDTH/4, 30) title:@"技能出售" font:18];
    rightLabel_bot.textColor = [UIColor colorWithRed:0.31f green:0.71f blue:0.53f alpha:1.00f];
    [bottomView addSubview:rightLabel_bot];
    
    UILabel *jineng= [MyControll createLabelWithFrame:CGRectMake(vWIDTH/2+10, 145,vWIDTH/4, 20) title:@"技能出售" font:13];
    jineng.textColor = [UIColor colorWithRed:0.76f green:0.76f blue:0.76f alpha:1.00f];
    [bottomView addSubview:jineng];
    
    UIButton *leftBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, vWIDTH/2, 200) bgImageName:nil imageName:nil title:nil selector:@selector(btnClick:) target:self];
    leftBtn.tag = 200;
    [bottomView addSubview:leftBtn];
    
    UIButton *right_topBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH/2, 0, vWIDTH/2, 100) bgImageName:nil imageName:nil title:nil selector:@selector(btnClick:) target:self];
    right_topBtn.tag = 201;
    [bottomView addSubview:right_topBtn];
    
    UIButton *right_botBtn = [MyControll createButtonWithFrame:CGRectMake(vWIDTH/2, 100, vWIDTH/2, 100) bgImageName:nil imageName:nil title:nil selector:@selector(btnClick:) target:self];
    right_botBtn.tag = 202;
    [bottomView addSubview:right_botBtn];
    
}
-(void)refreshUI
{
    pageControll.numberOfPages = self.adArray.count;
    pageControll.currentPage = 0;
    for (UIView *view in topSC.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < self.adArray.count; i ++) {
        UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(vWIDTH * i, 0, vWIDTH, 130) imageName:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"image"]]];
        [topSC addSubview:imageView];
        
        UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(10, 110, topSC.frame.size.width-100, 20) title:self.adArray[i][@"name"] font:10];
        titleLabel.textColor = [UIColor whiteColor];
        [imageView addSubview:titleLabel];
        
    }
    topSC.contentSize = CGSizeMake(vWIDTH*self.adArray.count, topSC.frame.size.height);
}
-(void)midImageBtnClick:(UIButton *)sender
{
    int index = (int)sender.tag-100;
    if (index==0) {
        RenQiViewController *vc = [[RenQiViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        NewActorViewController *vc = [[NewActorViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2)
    {
        HotViewController *vc = [[HotViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
    else if (index ==3)
    {
        GossipViewController *vc = [[GossipViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
        
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag-200;
    if (index == 0) {
        RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.uid =self.dataDic[@"id"];
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
//        OfflineViewController *vc =[[OfflineViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [_delegate.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2)
    {
        SkillSailViewController *vc = [[SkillSailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControll.currentPage = (scrollView.contentOffset.x+5)/scrollView.frame.size.width;

}

#pragma mark  每周一星
-(void)loadData:(BOOL)isReload
{
    if (!isReload) {
        return;
    }
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@weekstar?uid=%@&token=%@",SERVER_URL,uid,token];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count>0) {
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self refreshMeizhouYiXing];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)refreshMeizhouYiXing
{
    [imageView_left sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] placeholderImage:[UIImage imageNamed:@"26@2x_18"]];
}
#pragma mark   加载广告页
-(void)getAdData:(BOOL)isReload
{
    if (!isReload) {
        return;
    }
    if (_secDownManager) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@artlist?limit=10&page=1&type=3",SERVER_URL];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel1];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        NSLog(@"%@", array);
        self.adArray = [NSMutableArray arrayWithArray:array];
        [self refreshUI];
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    SAFE_CANCEL_ARC(self.secDownManager);
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
