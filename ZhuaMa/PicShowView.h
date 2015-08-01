//
//  PicShowView.h
//  ZhuaMa
//
//  Created by xll on 15/1/20.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@protocol PicShowDelegate <NSObject>

-(void)removeShowView;

@end

@interface PicShowView : BaseADView<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UIImage *tempImage;
}
@property(nonatomic)id<PicShowDelegate>delegate;
-(void)loadPicFromArray:(NSArray *)dataArray page:(int)page;
@end
