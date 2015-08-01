//
//  PicSelectView.m
//  ZhuaMa
//
//  Created by xll on 15/1/28.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PicSelectView.h"

@implementation PicSelectView

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
-(void)tap:(UIGestureRecognizer *)sender
{
    [_delegate picSelect:self Camera:nil Album:nil Flag:0];
}
-(void)makeUI
{
    self.backgroundColor = [UIColor clearColor];
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    UIView *shadowView =[MyControll createViewWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:shadowView];
    
   UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择你要上传图片的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [actionSheet showInView:self];
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex !=0&&buttonIndex !=1) {
        [_delegate picSelect:self Camera:nil Album:nil Flag:0];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if(buttonIndex == 1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        //如果选择是相机，需要判断相机是否可以开启
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [_delegate presentViewController:picker animated:YES completion:nil];
        }
        else
        {
             [_delegate picSelect:self Camera:nil Album:nil Flag:0];
        }
    }
    else
    {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = _maxCount;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [_delegate presentViewController:picker animated:YES completion:NULL];
    }
    
}
#pragma mark  获取图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获取照片
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //进行相应记录
    
    int miWidth = 600;
    int  miHeight = 600;
    int iWidth = image.size.width;
    int iHeight = image.size.height;
    
    
    if (iWidth > iHeight) {
        if (iWidth>miWidth) {
            iWidth = miWidth;
            iHeight = image.size.height*iWidth/image.size.width;
        }
        else
        {
            if (iHeight>miHeight) {
                iHeight = miHeight;
                iWidth = image.size.width*iHeight/image.size.height;
            }
        }
    }
    image = [self scaleToSize:image :CGSizeMake(iWidth, iHeight)];
    
    NSData *data = nil;
    NSString *picType;
    if (UIImagePNGRepresentation(image)) {
        
        data = UIImageJPEGRepresentation(image, 0.8);
        picType = @"jpg";
    }else{
        data = UIImageJPEGRepresentation(image, 0.8);
        picType = @"jpg";
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
    NSDate *date =[NSDate date];
    NSString *str = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]];
    filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,str,picType];
    [data writeToFile:filePath atomically:YES];
    [_delegate dismissViewControllerAnimated:YES completion:nil];
    [_delegate  picSelect:self Camera:filePath Album:nil Flag:1];
    
}
//图片缩放
- (UIImage *)scaleToSize:(UIImage *)image1 :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image1 drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_delegate dismissViewControllerAnimated:YES completion:nil];
    [_delegate picSelect:self Camera:nil Album:nil Flag:0];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        int miWidth = 600;
        int  miHeight = 600;
        int iWidth = tempImage.size.width;
        int iHeight = tempImage.size.height;
        
        if (iWidth > iHeight) {
            if (iWidth>miWidth) {
                iWidth = miWidth;
                iHeight = tempImage.size.height*iWidth/tempImage.size.width;
            }
            else
            {
                if (iHeight>miHeight) {
                    iHeight = miHeight;
                    iWidth = tempImage.size.width*iHeight/tempImage.size.height;
                }
            }
        }
        tempImage = [self scaleToSize:tempImage :CGSizeMake(iWidth, iHeight)];
        
        NSData *data = nil;
        NSString *picType;
        if (UIImagePNGRepresentation(tempImage)) {
            
            data = UIImageJPEGRepresentation(tempImage, 0.8);
            picType = @"jpg";
        }else{
            data = UIImageJPEGRepresentation(tempImage, 0.8);
            picType = @"jpg";
        }
        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
        NSDate *date =[NSDate date];
        NSString *str = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]+(i+1)*100];
        filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,str,picType];
        [data writeToFile:filePath atomically:YES];
        [self.uploadPicArray addObject:filePath];
        }
    [_delegate picSelect:self Camera:nil Album:self.uploadPicArray Flag:2];

}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
     [_delegate picSelect:self Camera:nil Album:nil Flag:0];
}
@end
