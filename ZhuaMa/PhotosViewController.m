//
//  PhotosViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/15.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PhotosViewController.h"
#import "ZYQAssetPickerController.h"
#import "ASIDownManager.h"
#import "LunBoTuViewController.h"
@interface PhotosViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *mainSC;
    BOOL isSelect;
    UIButton *deleteBtn;
    BOOL isDelete;
}
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)ASIDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSelect = NO;
    isDelete = NO;
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的相册" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    deleteBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"删除" selector:@selector(deleteClick) target:self];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    deleteBtn.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    mainSC.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainSC];
    [self refreshUI];
}
-(void)refreshUI
{
    float width = (WIDTH - 5*5)/4;
    for (int i = 0; i<self.picArray.count+1; i++) {
        if (i<self.picArray.count) {
            UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(5+(width+5)*(i%4), 10+(width+5)*(i/4), width, width) imageName:nil];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]] placeholderImage:[UIImage imageNamed:@"90"]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            imageView.tag = 100+i;
            [mainSC addSubview:imageView];
        }
        else
        {
            UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(5+(width+5)*(i%4), 10+(width+5)*(i/4), width, width) bgImageName:@"88" imageName:nil title:nil selector:@selector(addPic) target:self];
            [mainSC addSubview:btn];
        }
    }
    mainSC.contentSize = CGSizeMake(WIDTH, self.picArray.count * 80);

}
-(void)addPic
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 6;
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
    
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)tap:(UIGestureRecognizer *)sender
{
    if (isSelect) {
        return;
    }
    else
    {
        LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [vc picShow:self.picArray atIndex:sender.view.tag-100];
        [self presentViewController:vc animated:NO completion:nil];
    }
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        isSelect = !isSelect;
        if (isSelect) {
            deleteBtn.hidden = NO;
            float width = (WIDTH - 5*5)/4;
            for (int i = 0; i<self.picArray.count; i++) {
                UIButton *selectBtn = [MyControll createButtonWithFrame:CGRectMake(5+(width+5)*(i%4+1)-width/2, (width+5)*(i/4)+8, width/2, width/2) bgImageName:nil imageName:@"weixuan" title:nil selector:@selector(selectClick:) target:self];
                [selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                selectBtn.tag = 200+i;
                selectBtn.selected = NO;
                [mainSC addSubview:selectBtn];
            }
        }
        else
        {
            deleteBtn.hidden = YES;
            for (int i = 0; i<self.picArray.count; i++) {
                UIButton *selectBtn = (UIButton *)[mainSC viewWithTag:200+i];
                [selectBtn removeFromSuperview];
                selectBtn = nil;
            }
        }
    }
}
-(void)selectClick:(UIButton *)sender
{
    int index = (int)sender.tag-200;
    BOOL beSelect = sender.selected;
    if (beSelect) {
        sender.selected = NO;
        NSString *tempStr = self.picArray[index];
        [self.selectArray removeObject:tempStr];
    }
    else
    {
        sender.selected = YES;
        NSString *tempStr = self.picArray[index];
        [self.selectArray addObject:tempStr];
    }
}
-(void)deleteClick
{
    if (self.selectArray.count == 0) {
        [self showMsg:@"至少选择一张图片"];
        return;
    }
    for (NSString *tempStr in self.selectArray) {
        [self.picArray removeObject:tempStr];
    }
    isDelete = YES;
    [self commit];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    [self StartLoading];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//                    });
                    for (int i=0; i<assets.count; i++) {
                        ALAsset *asset=assets[i];
                        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
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
                                
                                data = UIImageJPEGRepresentation(image, 0.85);
                                picType = @"jpg";
                            }else{
                                data = UIImageJPEGRepresentation(image, 0.85);
                                picType = @"jpg";
                            }
                            NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
                            NSDate *date =[NSDate date];
                            NSString *str = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]+(i+1)*100];
                            filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,str,picType];
                            [data writeToFile:filePath atomically:YES];
                            [self.uploadPicArray addObject:filePath];
                        
                    }

                            [self commit];
//    });
   
}
//图片缩放
- (UIImage *)scaleToSize:(UIImage *)image :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark  完成提交
-(void)commit
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
//    [self StartLoading];

    NSString *urlstr = [NSString stringWithFormat:@"%@updateuserinfo2",SERVER_URL];
    self.mDownManager= [[ASIDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    
    
    NSMutableDictionary *d= [NSMutableDictionary dictionaryWithCapacity:0];
    [d setObject:uid forKey:@"uid"];
    [d setObject:token forKey:@"token"];
    if (isDelete) {
        [self StartLoading];
    [self.uploadPicArray removeAllObjects];
    }
    
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:self.picArray  forKey:@"image"];
        [d setObject:[dict JSONRepresentation] forKey:@"content"];
//    }
//    else{
//        [d setObject:@"" forKey:@"content"];
//    }
    if (self.uploadPicArray.count != 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i<self.uploadPicArray.count; i++) {
            [dic setObject:self.uploadPicArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
        }
        [_mDownManager PostHttpRequest:urlstr :d files:dic];
    }
    else
    {
        [_mDownManager PostHttpRequest:urlstr :d files:nil];
    }
}
-(void)OnLoadFinish:(ASIDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            if (isDelete) {
                [self showMsg:@"删除成功"];
                for (UIView *view in mainSC.subviews) {
                    [view removeFromSuperview];
                }
                [self refreshUI];
                isDelete = NO;
                isSelect = NO;
                deleteBtn.hidden = YES;
                [self.selectArray removeAllObjects];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
            }
            else
            {
                [self showMsg:@"上传成功"];
               [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                [self performSelector:@selector(GoBack1) withObject:self afterDelay:1];

            }
        }
        else
        {
            [self showMsg:dict[@"msg"]];
        }
    }
}
-(void)GoBack1
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)OnLoadFail:(ASIDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.mDownManager.delegate = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
