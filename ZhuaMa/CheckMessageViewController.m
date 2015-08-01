//
//  CheckMessageViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "CheckMessageViewController.h"
#import "ChatTableViewCell.h"
@interface CheckMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_tableView;
    UIView *txView;
    UITextView *textView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@end

@implementation CheckMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:_name font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self createTableView];
    [self createCommentView];
    [self loadData];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 60)];
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = self.dataArray[indexPath.row][@"text"];
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(200, 1000)];
    }
    
    if (size.height <50 + 30) {
        return 60 + 40 ;
    }
    return size.height +80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [textView resignFirstResponder];
}
#pragma mark  创建评论框
-(void)createCommentView
{
    txView = [MyControll createViewWithFrame:CGRectMake(0, HEIGHT - 60 -64, WIDTH, 60)];
    txView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:txView];
    
    UIImageView *bgView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 60) imageName:@"76"];
    bgView.userInteractionEnabled = YES;
    [txView addSubview:bgView];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(55, 10, WIDTH - 55 - 70, 40)];
    textView.layer.cornerRadius = 5;
    textView.font = [UIFont systemFontOfSize:14];
    textView.delegate = self;
    textView.clipsToBounds = YES;
    //    [textView becomeFirstResponder];
    [bgView addSubview:textView];
    
    UIButton *faceBtn = [MyControll createButtonWithFrame:CGRectMake(20, 0, 25, 60) bgImageName:nil imageName:@"73" title:nil selector:@selector(faceClick) target:self];
    [bgView addSubview:faceBtn];
    
    
    
    UIButton *sendBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 60, 0, 50, 60) bgImageName:nil imageName:@"75" title:nil selector:@selector(sendClick) target:self];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:sendBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)keyboardShow:(NSNotification *)notification
{
    //计算键盘高度
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
        txView.frame = CGRectMake(0,HEIGHT - height -60, self.view.frame.size.width, 60);
    }];
    
}
-(void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        txView.frame = CGRectMake(0, HEIGHT - 60, WIDTH, 60);
    }];
}
-(void)sendClick
{
    [textView resignFirstResponder];
    if ([textView.text length]==0) {
        [self showMsg:@"评论信息不能为空！"];
        return;
    }
    [textView resignFirstResponder];
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    //    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@sendmessage?uid=%@&token=%@&tid=%@&text=%@",SERVER_URL,uid,token,_tid,textView.text];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}
-(void)faceClick
{
    
}
#pragma mark  发信息
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            textView.text = @"";
            [self showMsg:@"提交成功"];
        }
        else
        {
            [self showMsg:@"提交失败"];
        }
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}
#pragma mark  获取数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@messagelist?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,_tid];
    self.mDownManager= [[ImageDownManager alloc]init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSArray *array = [resStr JSONValue];
    [self Cancel];
    if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
        NSLog(@"%@", array);
        [self.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    }
    else if(array.count == 0)
    {
        [self showMsg:@"没有数据"];
        [_tableView reloadData];
    }
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
