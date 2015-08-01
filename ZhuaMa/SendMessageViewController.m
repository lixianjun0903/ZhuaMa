//
//  SendMessageViewController.m
//  ZhuaMa
//
//  Created by xll on 15/1/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SendMessageViewController.h"
#import "MJRefresh.h"
#import "ChatTableViewCell.h"
#import "EmoticonView.h"
@interface SendMessageViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UITextViewDelegate,emoticonDelegate>
{
    UIButton *faceBtn;
    EmoticonView *emoticonView;
    UIPageControl *pageControl;
    
    
    //存储emoticon图片的数组
    NSMutableArray *_emoticonArray;
    //存储图片的名字在textView中得位置
    NSMutableArray *_textRangeArray;
    
    UIView *BQView;
    BOOL IsBQshow;
    BOOL isSelect;
    BOOL isDeleteView;
    
    UITableView *_tableView;
    UIView *txView;
    UITextView *textView;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int mpage;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mpage = 0;
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
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;
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
    
    faceBtn = [MyControll createButtonWithFrame:CGRectMake(20, 0, 25, 60) bgImageName:nil imageName:@"73" title:nil selector:@selector(faceClick:) target:self];
    [faceBtn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateSelected];
    faceBtn.selected = YES;
    [bgView addSubview:faceBtn];
    
    
    
    UIButton *sendBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 60, 0, 50, 60) bgImageName:nil imageName:@"75" title:nil selector:@selector(sendClick) target:self];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:sendBtn];
    
    
    
    
    isSelect = YES;
    isDeleteView = NO;
    _emoticonArray = [[NSMutableArray alloc] init];
    _textRangeArray = [[NSMutableArray alloc] init];
    
    
    [self createEmoticonView];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)createEmoticonView
{
    BQView  = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 170)];
    BQView.hidden = YES;
    BQView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BQView];
    emoticonView = [[EmoticonView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 120)];
    emoticonView.contentSize = CGSizeMake(CGRectGetWidth(BQView.frame)*3, 120);
    emoticonView.delegate = self;
    emoticonView.emoticonDelegate = self;
    emoticonView.selectImage = @selector(emoticonViewSelectImage:);
    emoticonView.deleteImage = @selector(emoticonViewDeleteImage);
    emoticonView.pagingEnabled = YES;
    emoticonView.showsHorizontalScrollIndicator = NO;
    emoticonView.showsVerticalScrollIndicator = NO;
    emoticonView.backgroundColor = [UIColor whiteColor];
    [BQView addSubview:emoticonView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(BQView.frame)-20, CGRectGetWidth(BQView.frame), 15)];
    pageControl.numberOfPages = 3;
    pageControl.tintColor = [UIColor blackColor];
    [BQView addSubview:pageControl];
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}
-(void)faceClick:(UIButton *)sender
{   isDeleteView = NO;
    isSelect = !isSelect;
    if (isSelect) {
        IsBQshow = YES;
        sender.selected = YES;
        [textView resignFirstResponder];
    }
    else
    {
        sender.selected = NO;
        [textView becomeFirstResponder];
    }
}
-(void)keyboardWillShow:(NSNotification *)notification
{
    faceBtn.selected = NO;
    isSelect = NO;
    //获取键盘的参数
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (duration == 0) {
        duration = 0.1;
    }
    
    NSLog(@"dict ======= %@",dict);
    NSLog(@"keyboardFrame ====== %@",NSStringFromCGRect(keyboardFrame));
    NSLog(@"CGRectGetMinY(keyboardFrame) ===== %f",CGRectGetMinY(keyboardFrame));
    //    if (IsBQshow) {
    [UIView animateWithDuration:duration animations:^{
        txView.frame = CGRectMake(0,HEIGHT - CGRectGetHeight(keyboardFrame)-60, WIDTH, 60);
        BQView.frame = CGRectMake(0, HEIGHT-64, WIDTH, 170);
    } completion:^(BOOL finished) {
        if (finished) {
            BQView.hidden = YES;
        }
    }];
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    faceBtn.selected = YES;
    isSelect = YES;
    NSDictionary *dict = [notification userInfo];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (!isDeleteView) {
        [UIView animateWithDuration:duration-0.1 animations:^{
            BQView.hidden = NO;
            BQView.frame = CGRectMake(0, HEIGHT-170, WIDTH, 170);
            txView.frame = CGRectMake(0, HEIGHT-170-60, WIDTH, 60);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:duration-0.1 animations:^{
            BQView.hidden = YES;
            txView.frame = CGRectMake(0, HEIGHT-60, WIDTH, 60);
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"text ==== %@",text);
    NSLog(@"textView.text ==== %@",textView.text);
    NSLog(@"range ==== %@",NSStringFromRange(range));
    
    if (range.length == 1) {
        
        int index=0;
        for (NSString *rangeStr in _textRangeArray) {
            NSRange imageRange = NSRangeFromString(rangeStr);
            
            //如果删除的是图片的名字
            if (NSLocationInRange(range.location, imageRange)) {
                
                NSMutableString *tempText = [[NSMutableString alloc] initWithString:textView.text];
                [tempText deleteCharactersInRange:imageRange];
                textView.text = tempText;
                
                //控制光标的位置
                textView.selectedRange = imageRange;
                
                //重新设置image的range
                int length = imageRange.length;
                for (int i=index+1; i<_textRangeArray.count; i++) {
                    NSRange tempRange = NSRangeFromString([_textRangeArray objectAtIndex:i]);
                    tempRange = NSMakeRange(tempRange.location-length, tempRange.length);
                }
                
                //删除image
                [_textRangeArray removeObjectAtIndex:index];
                [_emoticonArray removeObjectAtIndex:index];
                return NO;
            }
            index++;
        }
    }
    return YES;
}

#pragma mark ----------------------------------- UIScrollView的协议方法 -------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == emoticonView) {
        int index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        pageControl.currentPage = index;
    }
}
//添加图片回调
- (void)emoticonViewSelectImage:(NSString *)imageName{
    NSLog(@"image ====== %@",imageName);
    NSString *text = [NSString stringWithFormat:@"%@%@",textView.text,imageName];
    textView.text = text;
    
    //记住图片名字在字典中得位置
    NSRange range = [text rangeOfString:imageName options:NSBackwardsSearch];
    [_textRangeArray addObject:NSStringFromRange(range)];
    [_emoticonArray addObject:imageName];
    
    NSLog(@"range ==== %@",NSStringFromRange(range));
}

//删除图片回调
- (void)emoticonViewDeleteImage{
    if (_emoticonArray.count>0) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:textView.text];
        
        NSString *deleteStr = [_emoticonArray lastObject];
        NSRange range = [text rangeOfString:deleteStr options:NSBackwardsSearch];
        
        [text deleteCharactersInRange:range];
        textView.text = text;
        [_emoticonArray removeLastObject];
        [_textRangeArray removeLastObject];
    }
}
-(void)sendClick
{
    [textView resignFirstResponder];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@sendmessage?uid=%@&token=%@&tid=%@&text=%@",SERVER_URL,uid,token,_tid,textView.text];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}
#pragma mark  发信息
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
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
    NSString *urlstr = [NSString stringWithFormat:@"%@messagehistorylist?uid=%@&token=%@&tid=%@&limit=10&page=%d",SERVER_URL,uid,token,_tid,mpage+1];
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
        if (mpage == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:array];
        mpage++;
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
#pragma mark - 数据下拉刷新和上拉加载更多
//刷新
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //如果是下拉刷新
    if(refreshView == _header)
    {
        NSLog(@"refreshView == _header");
        mpage = 0;
        [self loadData];
        
    }
    else
    {
        [self loadData];
    }
    
}
- (void)Cancel {
    [_header endRefreshing];
    [_footer endRefreshing];
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _header.scrollView = nil;
    _footer.scrollView = nil;
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
