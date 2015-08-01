//
//  MyInfoViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyshenqingViewController.h"
#import "MydongtaiViewController.h"
#import "MymessageViewController.h"
#import "YidurenmaiViewController.h"
#import "ErdurenmaiViewController.h"
#import "MyInfoDetailViewController.h"
#import "MybaoliaoViewController.h"
#import "SettingViewController.h"
#import "AddVViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "WXApi.h"
#import "UMSocialWechatHandler.h"
@interface MyInfoViewController ()<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    UIButton *headIcon;
    UILabel *nameLabel;
    UIButton *addV;
    UILabel *yingxiangliLabel;
    UIView * pointView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation MyInfoViewController

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

    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:235.0/256 green:234.0/256 blue:238.0/256 alpha:1];
    [self makeUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginRefresh) name:@"loginSuccess" object:nil];
    // Do any additional setup after loading the view.
}
-(void)loginRefresh
{
    [self loadData];
}
-(void)makeUI
{
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    sc.showsVerticalScrollIndicator = NO;
    sc.contentSize = CGSizeMake(WIDTH, 590 + 64 + 49);
    [self.view addSubview:sc];
    
    UIImageView *topImageView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 150) imageName:@"34@2x.png"];
    topImageView.backgroundColor = [UIColor redColor];
    topImageView.userInteractionEnabled = YES;
    [sc addSubview:topImageView];
    
   
    headIcon = [MyControll createButtonWithFrame:CGRectMake(20, 30, 90, 90) bgImageName:nil imageName:@"35@2x.png" title:nil selector:@selector(headIconClick) target:self];
    headIcon.clipsToBounds = YES;
    headIcon.layer.cornerRadius = 5;
    [topImageView addSubview:headIcon];
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(125, 60, 120, 20) title:@"Jurnnery" font:15];
    nameLabel.textColor = [UIColor whiteColor];
    [topImageView addSubview:nameLabel];
    
    CGSize size = [MyControll getSize:nameLabel.text Font:13 Width:120 Height:20];
    addV = [MyControll createButtonWithFrame:CGRectMake(nameLabel.frame.origin.x + size.width +10, 60, 55, 20) bgImageName:@"woyaojiawei@2x.png" imageName:nil title:nil selector:@selector(btnClick:) target:self];
    addV.tag = 100;
    [topImageView addSubview:addV];
    
    yingxiangliLabel = [MyControll createLabelWithFrame:CGRectMake(125, 85, 100, 20) title:@"影响力：1" font:13];
    yingxiangliLabel.textColor = [UIColor whiteColor];
    [topImageView addSubview:yingxiangliLabel];
    
    UIButton *rightBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 50, (topImageView.frame.size.height - 30)/2, 30, 30) bgImageName:@"jiantou@2x.png" imageName:nil title:nil selector:@selector(btnClick:) target:self];
    rightBtn.tag = 101;
    [topImageView addSubview:rightBtn];
    
    UIView *firstView = [MyControll createToolViewWithFrame:CGRectMake(0, 160, WIDTH, 200) withColor:[UIColor whiteColor] withNameArray:@[@"我的通告",@"我的动态",@"我的爆料",@"我的消息" ]];
    [sc addSubview:firstView];
    pointView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/5+40, 150+(50-5)/2, 5, 5)];
    pointView.layer.cornerRadius = 2.5;
    pointView.clipsToBounds = YES;
    pointView.hidden = !_isShow;
    pointView.backgroundColor = [UIColor redColor];
    [firstView addSubview:pointView];
    
    UIView *secondView = [MyControll createToolViewWithFrame:CGRectMake(0, 370, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"一度人脉",@"二度人脉"]];
    [sc addSubview:secondView];
    
    UIView *thirdView = [MyControll createToolViewWithFrame:CGRectMake(0, 480, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"邀请好友",@"更多设置"]];
    [sc addSubview:thirdView];
    for (int i = 0; i < 8; i++) {
        if (i < 4) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,160 +i * 50, WIDTH, 50)];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 102 + i;
            [sc addSubview:btn];
        }
        if (i >= 4&&i<6) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,170 + i * 50, WIDTH, 50)];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 102 + i;
            [sc addSubview:btn];
        }
        if (i>=6) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,180 + i * 50, WIDTH, 50)];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 102 + i;
            [sc addSubview:btn];
        }
    }
    [self makeItShow];
}
-(void)makeItShow
{
    pointView.hidden = !_isShow;
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    NSLog(@"%d",index);
    if (index == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邀请好友加V",@"上传身份证加V", nil];
        sheet.tag=200;
        [sheet showInView:self.view];
    }
    else if (index == 1)
    {
        [self headIconClick];
    }
    else if (index == 2)
    {
        MyshenqingViewController *vc = [[MyshenqingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(index == 3)
    {
        MydongtaiViewController *vc = [[MydongtaiViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(index == 4)
    {
        MybaoliaoViewController *vc = [[MybaoliaoViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 5)
    {
        _isShow =NO;
        pointView.hidden = YES;
        MymessageViewController *vc = [[MymessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 6)
    {
        YidurenmaiViewController *vc = [[YidurenmaiViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 7)
    {
        ErdurenmaiViewController *vc = [[ErdurenmaiViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 8)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"通过短信邀请",@"通过微信邀请", nil];
        sheet.tag=201;
        [sheet showInView:self.view];
    }
    else if (index == 9)
    {
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)headIconClick
{
    MyInfoDetailViewController *vc = [[MyInfoDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.infoDic = self.dataDic;
//    [vc refreshUI];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 200) {
        if (buttonIndex == 1) {
            AddVViewController *vc = [[AddVViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if (actionSheet.tag==201)
    {
        if (buttonIndex == 0) {
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://800888"]];
            [self sendSMS:@"邀请您加入抓马" recipientList:nil];
        }
        else if (buttonIndex == 1)
        {
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
            {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"邀请您加入抓马" image:[UIImage imageNamed:@"Icon-iphone-60@2x"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                    }
                }];

            }
        }
    }
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        {
        NSLog(@"Message cancelled");
        }
    else if (result == MessageComposeResultSent)
        {
            NSLog(@"Message sent");
        }
    
    else
    {
             NSLog(@"Message failed") ;
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
    NSString *urlstr = [NSString stringWithFormat:@"%@userinfo2?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,uid];
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
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count>0) {
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self refreshUI];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:self.dataDic[@"image"] forKey:@"image"];
        [user synchronize];
    }
    else if(dict.count == 0)
    {
        
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)refreshUI
{
    if (![self.dataDic[@"face"] isEqualToString:@""]) {
        [headIcon sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal];
    }
    nameLabel.text = self.dataDic[@"name"];
    CGSize size = [MyControll getSize:nameLabel.text Font:13 Width:120 Height:20];
    addV.frame =CGRectMake(nameLabel.frame.origin.x + size.width +10, 60, 55, 20);
    if (self.dataDic[@""]) {
        [addV setImage:[UIImage imageNamed:@"v"] forState:UIControlStateNormal];
    }
    yingxiangliLabel.text = [NSString stringWithFormat:@"影响力：%@",self.dataDic[@"source"]];
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
