//
//  UserInfoManager.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserInfoManager.h"
#import "sys/xattr.h"
#import <MediaPlayer/MediaPlayer.h>

static UserInfoManager *gUserManager = nil;

@implementation UserInfoManager

+ (UserInfoManager *)Share {
    if (!gUserManager) {
        gUserManager = [[UserInfoManager alloc] init];
    }
    return gUserManager;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - User Params

- (void)setMUserInfo:(UserDetailInfo *)value {
    _mUserInfo = value;
    if (value && value.mDict) {
        [[NSUserDefaults standardUserDefaults] setObject:value.mDict forKey:@"userinfo"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)mUserID {
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    if (userinfo && [userinfo isKindOfClass:[NSDictionary class]]) {
        return [userinfo objectForKey:@"id"];
    }
    return nil;
}

- (NSDictionary *)mUserData {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
}

+ (NSDate *)GetStartDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [df stringFromDate:date];
    return [df dateFromString:dateString];
}

+ (NSString *)GetFormatDateString:(NSDate *)date {
    NSDate *startdate = [UserInfoManager GetStartDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date toDate:startdate options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    int hour = [components hour];
    int minute = [components minute];
    int second = [components second];
    
    int iOffset = (hour*60+minute)*60+second;
    
    if (year == 0 && month == 0 && day < 2) {
        NSString *title = nil;
        if (day <= 0) {
            if (iOffset <= 0) {
                NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
                int hours = [components hour];
                int minutes = [components minute];
                if (hours == 0) {
                    return [NSString stringWithFormat:@"%d分钟前", minutes];
                }
                else if (hours <= 3) {
                    return [NSString stringWithFormat:@"%d小时前", hours];
                }
                else {
                    title = @"今天";
                }
            }
            else {
                title = @"昨天";
            }
        }
        else if (day == 1) {
            title = @"前天";
        }
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        return [df stringFromDate:date];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd HH:mm";
    return [df stringFromDate:date];
}

+ (NSString *)GetFormatDateByInterval:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [UserInfoManager GetFormatDateString:date];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (void)AddiCloudBackUp {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [UserInfoManager addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:docDir]];
    [UserInfoManager addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:libDir]];
}

@end
