//
//  TrendDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/25.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "TrendDetailViewController.h"
#import "RenmaiDetailViewController.h"
#import "JubaoViewController.h"
#import "ShareView.h"
#import "TrendTongzhiViewController.h"
#import "PicShowView.h"
#import "InputKeyboardView.h"
@interface TrendDetailViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ShareDelegate,PicShowDelegate,inputKeyboardDelegate>
{
    UIScrollView *mainSC;
    UIButton *headView;
    UIButton *name;
    UILabel *shenfen;
//    UILabel *content;
    UIScrollView *imageSC;
    UILabel *time;
    UIButton *zanBtn;
    UILabel *zanCount;
    UIButton *shareBtn;
    UILabel *shareCount;
    UIButton *commentBtn;
    UILabel *commentCount;
    UIView *bottomView;
    
    UIImageView *commentDetailView;
    InputKeyboardView *inputView;
    NSString *commentText;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property(nonatomic,strong)ImageDownManager *fourthDownManager;
@end

@implementation TrendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"动态详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *jubao = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"举报" selector:@selector(jubao) target:self];
    jubao.titleLabel.font = [UIFont systemFontOfSize:16];
    [jubao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:jubao];

    
    [self makeUI];
    [self loadData];
    
    
}
-(void)jubao
{
    JubaoViewController *vc = [[JubaoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id = self.dataDic[@"id"];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  主UI
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate  = self;
    [self.view addSubview:mainSC];
    headView = [MyControll createButtonWithFrame:CGRectMake(10, 20, 35, 35) bgImageName:nil imageName:@"90" title:nil selector:@selector(btnClick:) target:self];
    headView.hidden = YES;
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"90"]];
    headView.titleLabel.textAlignment = NSTextAlignmentLeft;
    headView.layer.cornerRadius = 3;
    headView.clipsToBounds = YES;
    headView.tag = 100;
    [mainSC addSubview:headView];
    
    name = [MyControll createButtonWithFrame:CGRectMake(55, 20, 60, 20) bgImageName:nil imageName:nil title:@"张仃" selector:@selector(btnClick:) target:self];
    name.hidden = YES;
    [name setTitleColor:[UIColor colorWithRed:169.0/256 green:179.0/256 blue:202.0/256 alpha:1] forState:UIControlStateNormal];
    [name setTitle:self.dataDic[@"name"] forState:UIControlStateNormal];
    name.tag = 101;
    name.titleLabel.font = [UIFont systemFontOfSize:15];
    [mainSC addSubview:name];
    
    shenfen = [MyControll createLabelWithFrame:CGRectMake(115, 20, self.view.frame.size.width - 20 - 115, 20) title:self.dataDic[@"type"] font:14];
    shenfen.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:shenfen];
    
//    content = [MyControll createLabelWithFrame:CGRectMake(55, 40, self.view.frame.size.width - 55 - 10, 40) title:nil font:15];
//    [mainSC addSubview:content];
    
    imageSC = [[UIScrollView alloc]initWithFrame:CGRectMake(55, 90, self.view.frame.size.width - 55 - 10, 60)];
    imageSC.showsHorizontalScrollIndicator = NO;
    [mainSC addSubview:imageSC];
    
    bottomView = [MyControll createViewWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 30)];
    bottomView.hidden = YES;
    [mainSC addSubview:bottomView];
    
    time = [MyControll createLabelWithFrame:CGRectMake(55, 0, 60, 30) title:@"今天12:00" font:13];
    time.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:time];
    
    zanBtn = [MyControll createButtonWithFrame:CGRectMake(130, 0, 20, 30) bgImageName:nil imageName:@"31" title:nil selector:@selector(btnClick:) target:self];
    [bottomView addSubview:zanBtn];
    zanBtn.tag = 102;
    zanCount = [MyControll createLabelWithFrame:CGRectMake(155, 0, 30, 30) title:@"12" font:13];
    zanCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:zanCount];
    
    shareBtn = [MyControll createButtonWithFrame:CGRectMake(185, 0, 20, 30) bgImageName:nil imageName:@"32" title:nil selector:@selector(btnClick:) target:self];
    shareBtn.tag = 103;
    [bottomView addSubview:shareBtn];
    shareCount = [MyControll createLabelWithFrame:CGRectMake(210, 0, 30, 30) title:@"23" font:13];
    shareCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:shareCount];
    
    commentBtn = [MyControll createButtonWithFrame:CGRectMake(240, 0, 20, 30) bgImageName:nil imageName:@"33" title:nil selector:@selector(btnClick:) target:self];
    [bottomView addSubview:commentBtn];
    commentBtn.tag = 104;
    commentCount = [MyControll createLabelWithFrame:CGRectMake(265, 0, 20, 30) title:@"3" font:13];
    commentCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:commentCount];
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    if (index == 4) {
        inputView = [[InputKeyboardView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        inputView.delegate = self;
        [self.view.window addSubview:inputView];
    }
    else if (index == 0||index == 1)
    {
        RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(index == 2)
    {
        if ([[self.dataDic[@"flag"]stringValue]isEqualToString:@"0"]) {
            [self zan];
        }
        else if ([[self.dataDic[@"flag"]stringValue]isEqualToString:@"1"])
        {
            [self deleteZan];
        }
    }
    else if (index == 3)
    {
        ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+200)];
        shareView.tag = 1000000000;
        shareView.delegate = self;
        shareView.type = @"3";
        shareView.tid = self.dataDic[@"id"];
        [self.tabBarController.view addSubview:shareView];
    }
}
-(void)shareViewClick:(int)buttonIndex
{
    ShareView *shareView = (ShareView *)[self.tabBarController.view viewWithTag:1000000000];
    if (buttonIndex == 4) {
        [shareView removeFromSuperview];
        shareView = nil;
    }
    else if (buttonIndex == 5)
    {
        NSString *snum = self.dataDic[@"snum"];
        int Snums = [snum intValue]+1;
        [self.dataDic setObject:[NSString stringWithFormat:@"%d",Snums] forKey:@"snum"];
        shareCount.text = self.dataDic[@"snum"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *name1 = [user objectForKey:@"name"];
        NSString *uid = [user objectForKey:@"uid"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:name1 forKey:@"name"];
        [dic setObject:uid forKey:@"uid"];
        NSMutableArray *zArray = self.dataDic[@"share"];
        [zArray addObject:dic];
        
        [commentDetailView removeFromSuperview];
        [self commentView];
        
    }
}
#pragma mark  获取数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@topicinfo?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_id];
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
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self config];
    }
    
    
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark  刷新UI
-(void)config
{
    
    
    if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"0"]) {
        [zanBtn setImage:[UIImage imageNamed:@"31"] forState:UIControlStateNormal];
    }
    else if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"1"])
    {
        [zanBtn setImage:[UIImage imageNamed:@"411"] forState:UIControlStateNormal];
    }
    
    
    headView.hidden = NO;
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"90"]];
    name.hidden = NO;
    [name setTitle:self.dataDic[@"name"] forState:UIControlStateNormal];
    shenfen.text =self.dataDic[@"type"];
    
    NSString *str = self.dataDic[@"text"];
//    CGSize size = [self getSize:str];
//    content.frame = CGRectMake(55, 40, WIDTH - 55 - 10, size.height + 20);
//    content.text = str;
    
    EmoticonView *eView = [[EmoticonView alloc] init];
    UIView *txView =[eView viewWithText:str andFrame:CGRectMake(55, 50, WIDTH-55-10, 1000) FontSize:15];
    [mainSC addSubview:txView];
    
    CGSize size = CGSizeMake(CGRectGetWidth(txView.frame), CGRectGetHeight(txView.frame));
    
    
    NSArray *picArray = self.dataDic[@"image"];
    if (picArray.count!=0) {
        float width  = 5;
        for (int i = 0; i<picArray.count; i++) {
            UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(width, 0, 60, 60) imageName:picArray[i]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picShow:)]];
            imageView.tag = 700000+i;
            [imageSC addSubview:imageView];
            width += 65;
        }
        imageSC.contentSize = CGSizeMake(width, 60);
        
        if (width<WIDTH-55-10) {
            imageSC.frame = CGRectMake(55, 40+size.height+20, width, 60);
        }
        else
        {
            imageSC.frame = CGRectMake(55, 40+size.height +20, WIDTH-55-10, 60);
        }
        
        bottomView.frame = CGRectMake(0, imageSC.frame.origin.y+60+10, WIDTH, 30);
        [self commentView];
    }
    else
    {
        imageSC.hidden = YES;
        bottomView.frame = CGRectMake(0, txView.frame.origin.y+txView.frame.size.height+10, WIDTH, 30);
        [self commentView];
    }
    bottomView.hidden = NO;
    zanCount.text = self.dataDic[@"znum"];
    shareCount.text = self.dataDic[@"snum"];
    commentCount.text = self.dataDic[@"cnum"];
}
-(void)commentView
{
    if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"0"]) {
        [zanBtn setImage:[UIImage imageNamed:@"31"] forState:UIControlStateNormal];
    }
    else if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"1"])
    {
        [zanBtn setImage:[UIImage imageNamed:@"411"] forState:UIControlStateNormal];
    }
    NSArray *shareArray = self.dataDic[@"share"];
    NSArray *commentArray = self.dataDic[@"comments"];
    NSArray *zanArray = self.dataDic[@"approval"];
    if (shareArray.count>0||commentArray.count>0||zanArray.count>0) {
        commentDetailView = [MyControll createImageViewWithFrame:CGRectMake(10, 300, WIDTH - 20, 200) imageName:@"67"];
        commentDetailView.userInteractionEnabled = YES;
        [mainSC addSubview:commentDetailView];
        float height = 5;
        if (zanArray.count>0) {
            UIView *zanView = [MyControll createViewWithFrame:CGRectMake(0, height, commentDetailView.frame.size.width, 20)];
            [commentDetailView addSubview:zanView];
            UIImageView *zan = [MyControll createImageViewWithFrame:CGRectMake(10, 0, 20, 20) imageName:@"68"];
            zan.contentMode = UIViewContentModeCenter;
            [zanView addSubview:zan];
            float width = 0;
            for (int i = 0; i<zanArray.count; i++) {
                if (width<WIDTH -75) {
                    NSDictionary *dic = zanArray[i];
                    CGSize size = [self getSize:dic[@"name"] Font:13 Width:100 Height:20];
                    UIButton *nameBtn = [MyControll createButtonWithFrame:CGRectMake(35+width, 0, size.width+5, 20) bgImageName:nil imageName:nil title:dic[@"name"] selector:@selector(zanNameClick:) target:self];
                    nameBtn.tag = 400+i;
                    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [nameBtn setTitleColor:[UIColor colorWithRed:0.46f green:0.53f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
                    [zanView addSubview:nameBtn];
                    width = width+size.width+10;
                }
            }
            height = height + 25;
        }
        
        
        if (shareArray.count>0) {
            UIView *shareView = [MyControll createViewWithFrame:CGRectMake(0, height, commentDetailView.frame.size.width, 25)];
            [commentDetailView addSubview:shareView];
            UIImageView *share = [MyControll createImageViewWithFrame:CGRectMake(10, 0, 20, 20) imageName:@"69"];
            share.contentMode = UIViewContentModeCenter;
            [shareView addSubview:share];
            float width = 0;
            for (int i = 0; i<shareArray.count; i++) {
                if (width<WIDTH -75) {
                    NSDictionary *dic = shareArray[i];
                    CGSize size = [self getSize:dic[@"name"] Font:13 Width:100 Height:20];
                    UIButton *nameBtn = [MyControll createButtonWithFrame:CGRectMake(35+width, 0, size.width+5, 20) bgImageName:nil imageName:nil title:dic[@"name"] selector:@selector(shareNameClick:) target:self];
                    nameBtn.tag = 400+i;
                    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [nameBtn setTitleColor:[UIColor colorWithRed:0.46f green:0.53f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
                    [shareView addSubview:nameBtn];
                    width = width+size.width+10;
                }
            }
            height = height + 25;
        }
        
        
        if (commentArray.count>0) {
            UIView *commentView = [MyControll createViewWithFrame:CGRectMake(0, height, commentDetailView.frame.size.width, 1000)];
            [commentDetailView addSubview:commentView];
            UIImageView *comment = [MyControll createImageViewWithFrame:CGRectMake(10, 0, 20, 20) imageName:@"70"];
            comment.contentMode = UIViewContentModeCenter;
            [commentView addSubview:comment];
            float cHeight = 0;
            for (int i = 0; i<commentArray.count; i++) {
                NSDictionary *dic = commentArray[i];
                CGSize size = [self getSize:dic[@"name"] Font:13 Width:100 Height:20];
                UIButton *nameBtn = [MyControll createButtonWithFrame:CGRectMake(35, cHeight, size.width+10, 20) bgImageName:nil imageName:nil title:[NSString stringWithFormat:@"%@:",dic[@"name"]] selector:@selector(commentNameClick:) target:self];
                nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                nameBtn.tag = 400+i;
                [nameBtn setTitleColor:[UIColor colorWithRed:0.46f green:0.53f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
                [commentView addSubview:nameBtn];
                
                EmoticonView *eView = [[EmoticonView alloc] init];
                UIView *txView =[eView viewWithText:dic[@"text"] andFrame:CGRectMake(35 +size.width +15, cHeight+2, WIDTH-15-35-size.width-10-5, 1000) FontSize:13];
                [commentView addSubview:txView];
                float contentHeight = txView.frame.size.height;
//                CGSize contentSize = [self getSize:dic[@"text"] Font:13 Width:WIDTH-20-35-size.width-10-5 Height:1000];
//                UILabel *contentLabel = [MyControll createLabelWithFrame:CGRectMake(35 +size.width +15, cHeight, WIDTH-15-35-size.width-10-5, contentSize.height +7) title:dic[@"text"] font:13];
//                [commentView addSubview:contentLabel];
                cHeight = cHeight + contentHeight;
            }
            height = height + cHeight;
        }
        commentDetailView.frame = CGRectMake(10, bottomView.frame.origin.y + 30 + 10, WIDTH-20, height+5);
        mainSC.contentSize = CGSizeMake(WIDTH, commentDetailView.frame.origin.y+commentDetailView.frame.size.height+10);
    }
    else
    {
        mainSC.contentSize = CGSizeMake(WIDTH, bottomView.frame.origin.y+30+10);
    }
    
}
-(void)zanNameClick:(UIButton *)sender
{
    
}
-(void)shareNameClick:(UIButton *)sender
{
    
}
-(void)commentNameClick:(UIButton *)sender
{
    
}
-(void)picShow:(UIGestureRecognizer *)sender
{
    int index = (int)sender.view.tag-700000;
    [self.navigationController setNavigationBarHidden:YES];
    NSArray *picArray = self.dataDic[@"image"];
    PicShowView *picShowView = [[PicShowView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    picShowView.tag = 20000;
    picShowView.delegate = self;
    [picShowView loadPicFromArray:picArray page:index];
    [self.tabBarController.view addSubview:picShowView];
}
-(void)removeShowView
{
    [self.navigationController setNavigationBarHidden:NO];
    PicShowView *picShowView = (PicShowView *)[self.tabBarController.view viewWithTag:20000];
    for (UIView *view in picShowView.subviews) {
        [view removeFromSuperview];
    }
    [picShowView removeFromSuperview];
}
-(void)btn:(UIButton *)sender
{
    RenmaiDetailViewController *vc = [[RenmaiDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  评论
-(void)inputKeyboardHide:(InputKeyboardView *)keyboardView
{
    [inputView removeFromSuperview];
}
-(void)inputKeyboardSendText:(NSString *)text
{
    commentText = text;
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@commentopic?uid=%@&token=%@&id=%@&text=%@&tid=%@",SERVER_URL,uid,token,_id,text,self.dataDic[@"uid"]];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"评论成功"];
            int  cnum =  [self.dataDic[@"cnum"] intValue];
            [self.dataDic setValue:[NSString stringWithFormat:@"%d",cnum +1] forKey:@"cnum"];
            commentCount.text = self.dataDic[@"cnum"];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *name1 = [user objectForKey:@"name"];
            NSString *uid = [user objectForKey:@"uid"];
            NSString *text = commentText;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:name1 forKey:@"name"];
            [dic setObject:uid forKey:@"uid"];
            [dic setObject:text forKey:@"text"];
            NSMutableArray *cArray = self.dataDic[@"comments"];
            [cArray addObject:dic];
            [commentDetailView removeFromSuperview];
            [self commentView];
        }
        else
        {
            [self showMsg:@"评论失败"];
        }
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}
#pragma mark  赞动态
-(void)zan
{
    if(_thirdDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@approval?uid=%@&token=%@&type=3&tid=%@",SERVER_URL,uid,token,self.dataDic[@"id"]];
    self.thirdDownManager= [[ImageDownManager alloc]init];
    _thirdDownManager.delegate = self;
    _thirdDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManager.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish2:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel2];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            int  znum =  [self.dataDic[@"znum"] intValue];
            [self.dataDic setValue:[NSString stringWithFormat:@"%d",znum +1] forKey:@"znum"];
            zanCount.text = self.dataDic[@"znum"];
            [self.dataDic setObject:[NSNumber numberWithInt:1] forKey:@"flag"];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *name1 = [user objectForKey:@"name"];
            NSString *uid = [user objectForKey:@"uid"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:name1 forKey:@"name"];
            [dic setObject:uid forKey:@"uid"];
            NSMutableArray *zArray = self.dataDic[@"approval"];
            [zArray addObject:dic];
            
            [commentDetailView removeFromSuperview];
            [self commentView];
        }
    }
    
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.thirdDownManager);
}
-(void)deleteZan
{
    if(_fourthDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@canclepraise?uid=%@&token=%@&id=%@&type=1",SERVER_URL,uid,token,self.dataDic[@"id"]];
    self.fourthDownManager= [[ImageDownManager alloc]init];
    _fourthDownManager.delegate = self;
    _fourthDownManager.OnImageDown = @selector(OnLoadFinish3:);
    _fourthDownManager.OnImageFail = @selector(OnLoadFail3:);
    [_fourthDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish3:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel3];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
            int  znum =  [self.dataDic[@"znum"] intValue];
            [self.dataDic setValue:[NSString stringWithFormat:@"%d",znum -1] forKey:@"znum"];
            zanCount.text = self.dataDic[@"znum"];
            [self.dataDic setObject:[NSNumber numberWithInt:0] forKey:@"flag"];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *name1 = [user objectForKey:@"name"];
            NSString *uid = [user objectForKey:@"uid"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:name1 forKey:@"name"];
            [dic setObject:uid forKey:@"uid"];
            NSMutableArray *zArray = self.dataDic[@"approval"];
            [zArray removeObject:dic];
            
            [commentDetailView removeFromSuperview];
            [self commentView];
        }
    }
    
}
- (void)OnLoadFail3:(ImageDownManager *)sender {
    [self Cancel3];
}
- (void)Cancel3 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.fourthDownManager);
}
#pragma mark 工具类
-(CGSize )getSize:(NSString *)str
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 55 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:13]constrainedToSize:CGSizeMake(self.view.frame.size.width - 55 - 10, 1000)];
    }
    return size;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:sizeofstr]constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
