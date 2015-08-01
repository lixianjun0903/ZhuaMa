//
//  UpdatePlace.h
//  ZhuaMa
//
//  Created by xll on 15/2/6.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationHandler.h"

@class UpdatePlace;

@protocol UpdatePlaceDelegate <NSObject>

-(void)didFinishUpdate:(UpdatePlace *)Model Long:(NSString *)log Lat:(NSString *)lat;
-(void)didFailUpdate;

@end

@interface UpdatePlace : NSObject<LocationHandlerDelegate>
@property(nonatomic,assign)id<UpdatePlaceDelegate>delegate;
-(void)updateplace;
@end
