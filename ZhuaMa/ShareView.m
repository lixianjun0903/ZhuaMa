//
//  shareView.m
//  ZhuaMa
//
//  Created by xll on 15/1/20.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.backgroundColor =[UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:bgView];
    
    
    
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
    UIView *shareView = [MyControll createViewWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, self.frame.size.width, 220)];
    
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame =CGRectMake(0, [[UIScreen mainScreen]bounds].size.height -220, self.frame.size.width, 220);
    }];
    shareView.tag = 70;
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.userInteractionEnabled = YES;
    [self addSubview:shareView];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake((self.frame.size.width-200)/2, 20, 200, 20) title:@"分享到" font:18];
    tishi.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:tishi];
    
    NSArray *sharePic = @[@"63"];
    NSArray *shareTitle = @[@"新浪微博"];
    
    
    for (int i = 0; i<sharePic.count; i++) {
        UIButton *sharebtn = [MyControll createButtonWithFrame:CGRectMake(10+self.frame.size.width/4 *i, 50, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20) bgImageName:nil imageName:sharePic[i] title:nil selector:@selector(shareBtnClick:) target:self];
        sharebtn.tag = 100000+i;
        [shareView addSubview:sharebtn];
        
        UILabel *shareLabel = [MyControll createLabelWithFrame:CGRectMake(self.frame.size.width/4 *i, 50 + self.frame.size.width/4, self.frame.size.width/4, 20) title:shareTitle[i] font:14];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = [UIColor lightGrayColor];
        [shareView addSubview:shareLabel];
    }
    float btnWidth = self.frame.size.width/4;
    float width_wx = 0;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + btnWidth * 1 , 50, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20)];
        wxBtn.layer.cornerRadius = 5;
        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 100001;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"62"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wxBtn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth * 1 , 50 + self.frame.size.width/4, btnWidth, 20)];
        l.textColor = [UIColor lightGrayColor];
        l.text =@"朋友圈";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
        width_wx = btnWidth;
    }
    else
    {
        
    }
    
    float width_hy = 0;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + btnWidth * 1 + width_wx , 50, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20)];
        wxBtn.layer.cornerRadius = 5;
        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 100002;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"60"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wxBtn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth * 1+ width_wx , 50 + self.frame.size.width/4, btnWidth, 20)];
        l.textColor = [UIColor lightGrayColor];
        l.text =@"微信好友";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
        width_hy = btnWidth;
    }
    else
    {
        
    }
    
    
    
    float witdh_qq = 0;
    if ([QQApi isQQInstalled]&&[QQApi isQQSupportApi]) {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 + btnWidth*1 + width_wx +width_hy, 50, self.frame.size.width/4 - 20, self.frame.size.width/4 - 20)];
        wxBtn.layer.cornerRadius = 5;
        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 100003;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"61"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wxBtn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*2 + width_wx , 50 + self.frame.size.width/4, btnWidth, 20)];
        l.textColor = [UIColor lightGrayColor];
        l.text =@"QQ好友";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:l];
        witdh_qq = btnWidth;
    }
    else
    {
        
    }
    
    UIButton *cancelBtn = [MyControll createButtonWithFrame:CGRectMake((self.frame.size.width-300)/2, 50 + self.frame.size.width/4+40, 300, 40) bgImageName:nil imageName:@"64" title:nil selector:@selector(shareBtnClick:) target:self];
    cancelBtn.tag = 100004;
    [shareView addSubview:cancelBtn];
}
-(void)shareBtnClick:(UIButton *)sender
{
    NSString *shareText =[NSString stringWithFormat:@"快来看看这个软件吧"];
    int index = sender.tag;
    UIImage *image = [UIImage imageNamed:@"Icon-iphone-40"];
    if (index == 100000) {
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享内嵌文字" shareImage:[UIImage imageNamed:@"Icon-iphone-40"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES);
    }
    else if (index == 100001)
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    else if (index == 100002)
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    else if (index == 100003)
    {
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享内嵌文字" shareImage:[UIImage imageNamed:@"Icon-iphone-40"] socialUIDelegate:self];        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler((UIViewController*)_delegate,[UMSocialControllerService defaultControllerService],YES);
    }
  else  if (sender.tag == 100004) {
       [_delegate shareViewClick:4];
    }
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate shareViewClick:4];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [self loadData];
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    else
    {
        [_delegate shareViewClick:4];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@share?uid=%@&token=%@&type=%@&tid=%@",SERVER_URL,uid,token,_type,_tid];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary  *dict = [resStr JSONValue];
    [self Cancel];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        if ([[dict[@"code"] stringValue] isEqualToString:@"1"]) {
            [_delegate shareViewClick:5];
        }
        else
        {
            [_delegate shareViewClick:0];
        }
        [_delegate shareViewClick:4];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
//    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

-(void)removeShareView{
    [self removeFromSuperview];
}
@end
