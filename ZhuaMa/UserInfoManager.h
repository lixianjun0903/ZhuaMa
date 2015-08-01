//
//  UserInfoManager.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetailInfo.h"
#import "SlidePopViewController.h"

@interface UserInfoManager : NSObject {
    
}

@property (nonatomic, strong) UserDetailInfo *mUserInfo;

+ (UserInfoManager *)Share;
+ (NSString *)GetFormatDateString:(NSDate *)date;
+ (NSString *)GetFormatDateByInterval:(NSTimeInterval)interval;
+ (void)AddiCloudBackUp;

#define kkUserInfo      [UserInfoManager Share].mUserInfo
#define kkUserID        kkUserInfo.userid

#define kMsg_PlayAudio  @"kMsg_PlayAudio"

#define SafePerformSelector(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kLibraryPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#ifndef IOS_7
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)
#endif

#define IsiPadUI (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsRetina CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)
#define IsiPhone5 CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
#define IsiPad CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size)

#define currentHeight [UIScreen mainScreen].bounds.size.height
#define currentWidth [UIScreen mainScreen].bounds.size.width

#define kDefault_Color [UIColor colorWithRed:0.97 green:0.43 blue:0.27 alpha:1.0]


@end
