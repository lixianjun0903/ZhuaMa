//
//  xllAppDelegate.m
//  ZhuaMa
//
//  Created by xll on 14/12/18.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "xllAppDelegate.h"
#import "FirstPageViewController.h"
#import "APService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MyInfoViewController.h"
@implementation xllAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //*********************分享部分*******************************************
    
    [UMSocialData setAppKey:APPKEY];
    [UMSocialData openLog:YES];
    
    
    [UMSocialWechatHandler setWXAppId:@"wx9b4db7dde8d4c2cc" appSecret:@"a3eaf9aee9f8c475ab7fe0e7b7cee645" url:@"http://www.zhuama.wang"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104059047" appKey:@"aetDfVl3ae47GrkD" url:@"http://www.zhuama.wang"];
        
    //*********************分享部分*******************************************

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
//    [APService setupWithOption:launchOptions];
    mLoadView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    mLoadView.image = [UIImage imageNamed:@"启动页(1).png"];
    mLoadView.userInteractionEnabled = YES;
    [self.window addSubview:mLoadView];
    
    _homeVC = [[HomeViewController alloc]init];
    
    FirstPageViewController *vc = [[FirstPageViewController alloc]init];
    _loginNav = [[NavRootViewController alloc]initWithRootViewController:vc];
    
    [self performSelector:@selector(ShowHomeView) withObject:self afterDelay:2];

    
    if (launchOptions) {
        NSDictionary* pushNotificationKey =　[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            //这里定义自己的处理方式
            NSLog(@"%@",[[launchOptions objectForKey:@"aps"] objectForKey:@"alert"]);
            NSArray *array =  _homeVC.itemsArray;
            UILabel *label = array[3];
            label.text = [NSString stringWithFormat:@"%@",[launchOptions objectForKey:@"items"]];
            label.hidden = NO;
            MyInfoViewController *vc = _homeVC.ctrl4;
            vc.isShow = YES;
            [vc makeItShow];
        }
    }
    
    return YES;
}

- (void)ShowHomeView {
    
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (uid&&token) {
        [self check];
    }
    else
    {
        self.window.rootViewController = _loginNav;
        [mLoadView removeFromSuperview];
    }
    
}
-(void)check
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token= [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@validToken?uid=%@&token=%@",SERVER_URL,uid,token];
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
    if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"]) {
      self.window.rootViewController = _homeVC;
        [mLoadView removeFromSuperview];
    }
    else
    {
        self.window.rootViewController = _loginNav;
        [mLoadView removeFromSuperview];
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    self.window.rootViewController = _loginNav;
    [mLoadView removeFromSuperview];
    [self Cancel];
}
- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark  JPush
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    
    NSString *deviceTokenStr =[NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:deviceTokenStr forKey:@"deviceToken"];
    [user synchronize];
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        
        NSLog(@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
        NSArray *array =  _homeVC.itemsArray;
        UILabel *label = array[3];
        label.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"items"]];
        label.hidden = NO;
        MyInfoViewController *vc = _homeVC.ctrl4;
        vc.isShow = YES;
        [vc makeItShow];
    }
    else {
        //第三种情况
        //这里定义自己的处理方式
    }

}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark  - me
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
@end
