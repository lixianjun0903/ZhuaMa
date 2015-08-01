//
//  CommentViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/24.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *txView;
    UITextView *textView;
    int startCount;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startCount = 0;
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"评论详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self createTableView];
    [self loadData];
    [self createTextFeild];
    // Do any additional setup after loading the view.
}
#pragma mark   建立tableView
-(void)createTableView
{
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.opaque = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSMutableString *str = [NSMutableString stringWithFormat:@"  "];
    for (int i= 0; i<[dic[@"name"] length]+1; i++) {
        [str appendString:@" "];
    }
    NSString *s = [NSString stringWithFormat:@"%@%@",str,dic[@"text"]];
    CGSize size = [s boundingRectWithSize:CGSizeMake(WIDTH - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    return size.height +30+16;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [textView resignFirstResponder];
}
#pragma mark  建立输入文本域
-(void)createTextFeild
{
    txView = [MyControll createViewWithFrame:CGRectMake(0, HEIGHT - 100 - 64, WIDTH, 100)];
    txView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:txView];
    UILabel *dafenLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, 60, 20) title:@"请打分" font:15];
    dafenLabel.textColor = [UIColor lightGrayColor];
    [txView addSubview:dafenLabel];
    for (int i = 0; i< 5; i++) {
        UIButton *heartBtn = [MyControll createButtonWithFrame:CGRectMake(80 + i * 28, 10, 24, 24) bgImageName:nil imageName:@"82" title:nil selector:@selector(heartBtnClick:) target:self];
        [heartBtn setImage:[UIImage imageNamed:@"81"] forState:UIControlStateSelected];
        heartBtn.tag = 10 + i;
        [txView addSubview:heartBtn];
    }
    
    UIImageView *bgView = [MyControll createImageViewWithFrame:CGRectMake(0, 40, WIDTH, 60) imageName:@"76"];
    bgView.userInteractionEnabled = YES;
    [txView addSubview:bgView];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 10 - 55, 40)];
    textView.layer.cornerRadius = 5;
    textView.font = [UIFont systemFontOfSize:14];
    textView.clipsToBounds = YES;
    [bgView addSubview:textView];
    
    UIButton *sendBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 50, 0, 40, 60) bgImageName:nil imageName:nil title:@"发送" selector:@selector(sendClick) target:self];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:sendBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardShow:(NSNotification *)notification
{
    //计算键盘高度
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
        txView.frame = CGRectMake(0, HEIGHT - height - 100, self.view.frame.size.width, 100);
    }];
    
}
-(void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
       txView.frame = CGRectMake(0, HEIGHT - 100, WIDTH, 100);
    }];
}
-(void)sendClick
{
    if ([textView.text length]==0) {
        [self showMsg:@"评论信息不能为空！"];
        return;
    }
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
//    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@createcomment?uid=%@&token=%@&text=%@&star=%d&id=%@",SERVER_URL,uid,token,textView.text,startCount,_id];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];

}
-(void)heartBtnClick:(UIButton *)sender
{
    for (int i = 0; i<=sender.tag - 10; i++) {
        UIButton *btn = (UIButton *)[txView viewWithTag:10 + i];
        btn.selected = YES;
    }
    for (int i = 14; i > sender.tag - 10; i--) {
        UIButton *btn = (UIButton *)[txView viewWithTag:10 + i];
        btn.selected = NO;
    }
    startCount = (int)sender.tag-10+1;
}
#pragma mark  加载数据
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@commentlist?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_id];
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
        [self.dataArray removeAllObjects];
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [_tableView reloadData];
    }
    else if(array.count == 0)
    {
        [self showMsg:@"没有数据"];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark  评论提交
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commentSuccess" object:nil];
        }
        else
        {
            [self showMsg:@"评论失败"];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
