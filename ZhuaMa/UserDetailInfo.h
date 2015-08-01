//
//  BBSListInfo.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailInfo : NSObject {
    
}

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;

+ (UserDetailInfo *)CreateWithDict:(NSDictionary *)dict;

@end
