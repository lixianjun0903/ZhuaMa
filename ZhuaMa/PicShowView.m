//
//  PicShowView.m
//  ZhuaMa
//
//  Created by xll on 15/1/20.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PicShowView.h"
#import "SizeImageView.h"
@implementation PicShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.pagingEnabled = YES;
    mainSC.backgroundColor = [UIColor blackColor];
    [self addSubview:mainSC];
}
-(void)loadPicFromArray:(NSArray *)dataArray page:(int)page
{
    for (int i = 0; i<dataArray.count; i++) {
        SizeImageView *imageView = [[SizeImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [imageView getImageFromURL:dataArray[i]];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:) ]];
        [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
        [mainSC addSubview:imageView];
    }
    mainSC.contentOffset = CGPointMake(page *self.frame.size.width, self.frame.size.height);
    mainSC.contentSize = CGSizeMake(self.frame.size.width * dataArray.count, self.frame.size.height);
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate removeShowView];
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        SizeImageView *tempView = (SizeImageView *)sender.view;
        tempImage = tempView.mZoomView.image;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定保存图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else
    {
        if (tempImage != nil) {
            UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil,nil);
        }
    }
    
}
@end
