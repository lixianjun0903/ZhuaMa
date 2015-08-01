//
//  GetCheckMaView.h
//  ZhuaMa
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GetCheckDelegate <NSObject>
-(void)getCheckMa;
-(void)buttonClick;
@end


@interface GetCheckMaView : UIView
@property(nonatomic)id<GetCheckDelegate>delegate;
-(void)startCheck;
@end
