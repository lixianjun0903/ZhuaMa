//
//  FeedBackViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/14.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>
{
    UITextView *textView;
    UILabel *tishiLabel;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.93f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"用户反馈" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    UIView *bgView = [MyControll createViewWithFrame:CGRectMake(0, 20, WIDTH, 170)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, WIDTH-40, 150)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:textView];
    
    tishiLabel = [MyControll createLabelWithFrame:CGRectMake(23, 16, 160, 20) title:@"请输入你的建议或反馈" font:15];
    tishiLabel.textColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.00f];
    [bgView addSubview:tishiLabel];
    
    
    UIButton *confirmBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 220, 260, 40) bgImageName:nil imageName:@"wanc" title:nil selector:@selector(confirmClick:) target:self];
    [self.view addSubview:confirmBtn];
}
-(void)confirmClick:(UIButton *)sender
{
    if (textView.text.length == 0) {
        [self showMsg:@"反馈不能为空"];
        return;
    }
    [self commit];
}
-(void)textViewDidChange:(UITextView *)textView1
{
    if (textView ==textView1) {
        if (textView.text.length>0) {
            tishiLabel.hidden = YES;
        }
        else{
            tishiLabel.hidden = NO;
        }
    }

}
-(void)commit
{
    if(_mDownManager)
    {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@fankui?uid=%@&token=%@&text=%@",SERVER_URL,uid,token,textView.text];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
        NSLog(@"提交反馈成功");
        [self showMsg:@"提交反馈成功"];
        [self performSelector:@selector(GoBack) withObject:nil afterDelay:0.5];
    }
    else{
        [self showMsg:@"提交反馈失败"];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
