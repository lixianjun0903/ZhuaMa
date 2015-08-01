//
//  shareView.h
//  ZhuaMa
//
//  Created by xll on 15/1/20.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol ShareDelegate <NSObject>

-(void)shareViewClick:(int)buttonIndex;

@end



@interface ShareView : BaseADView<UMSocialDataDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)id <ShareDelegate>delegate;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *tid;
@end
