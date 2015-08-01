//
//  UpdatePlace.m
//  ZhuaMa
//
//  Created by xll on 15/2/6.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "UpdatePlace.h"

@implementation UpdatePlace

-(void)updateplace
{
    [[LocationHandler getSharedInstance]setDelegate:self];
    [[LocationHandler getSharedInstance]startUpdating];
}
-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    [_delegate didFinishUpdate:self Long:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] Lat:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude]];
    [[LocationHandler getSharedInstance]stopUpdating];
}
-(void)didFailWithError:(NSError *)error
{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setObject:@"NO" forKey:@"isDingwei"];
//    [user synchronize];
    [_delegate didFailUpdate];
    [[LocationHandler getSharedInstance]stopUpdating];
}
@end
