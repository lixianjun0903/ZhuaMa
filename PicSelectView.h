//
//  PicSelectView.h
//  ZhuaMa
//
//  Created by xll on 15/1/28.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
#import "ZYQAssetPickerController.h"

@class PicSelectView;
@protocol PicSelectDelegate <NSObject>

-(void)picSelect:(PicSelectView *)picSelectView Camera:(NSString *)filePath Album:(NSMutableArray *)array Flag:(int)flag;

@end

@interface PicSelectView : BaseADView<UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *image;
//    UIActionSheet *actionSheet;
}
@property(nonatomic)UIViewController<PicSelectDelegate>*delegate;
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic)int maxCount;
@end
