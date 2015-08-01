//
//  RenmaiDetailViewController.m
//  ZhuaMa
//
//  Created by xll on 14/12/30.
//  Copyright (c) 2014年 xll. All rights reserved.
//

#import "RenmaiDetailViewController.h"
#import "JubaoViewController.h"
#import "SendMessageViewController.h"
#import "PhotoCheckViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface RenmaiDetailViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    
    UIButton *zanBtn;
    UILabel *zanCount;
    UIButton *shareBtn;
    UILabel *shareCount;
    UIButton *commentBtn;
    UILabel *commentCount;
    UIView *bottomView;
    UIImageView *commentDetailView;
    
    UILabel *phone;
    UILabel *email;
    UILabel *weichat;
    
    UITextField *biaoqianTX;
    
    NSString *biaoqianContent;
    
    UIView * fourView;
    UIView *fifthView;
    UIView *sixthView;
    UILabel *commentLabel;
    UILabel *jingliDesc;
    UILabel *jingliLabel;
    UIImageView *headView;
}
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation RenmaiDetailViewController

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
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"人脉详情" font:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"38" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *jubao = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"举报" selector:@selector(jubao) target:self];
    [jubao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:jubao];

    
    [self loadData];
   
}
-(void)jubao
{
    JubaoViewController *vc = [[JubaoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.id  = self.dataDic[@"id"];
    vc.type = 3;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark  主要UI
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.opaque = NO;
    mainSC.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    mainSC.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mainSC.contentSize = CGSizeMake(WIDTH, 830);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    
    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 10, 60, 60) imageName:@"90"];
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] placeholderImage:[UIImage imageNamed:@"90"]];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 3;
    [firstView addSubview:headView];
    
    UILabel *nameLabel = [MyControll createLabelWithFrame:CGRectMake(100, 10, 200, 20) title:nil font:16];
    nameLabel.text = self.dataDic[@"name"];
    [firstView addSubview:nameLabel];
    
    CGSize size = [MyControll getSize:nameLabel.text Font:16 Width:200 Height:20];
    UIImageView *addV = [MyControll createImageViewWithFrame:CGRectMake(nameLabel.frame.origin.x + size.width +10, 10, 15, 20) imageName:@"v"];
    addV.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:addV];
    
    UILabel *zhiweiLabel = [MyControll createLabelWithFrame:CGRectMake(100, 30, 200, 20) title:nil font:14];
    zhiweiLabel.text = self.dataDic[@"type"];
    zhiweiLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:zhiweiLabel];
    
    UILabel *yingxiangli = [MyControll createLabelWithFrame:CGRectMake(100, 50, 200, 20) title:nil font:14];
    yingxiangli.text = [NSString stringWithFormat:@"影响力：%@",self.dataDic[@"source"]];
    yingxiangli.textColor = [UIColor lightGrayColor];
    [firstView addSubview:yingxiangli];
    
    
    
    phone = [MyControll createLabelWithFrame:CGRectMake(20, 80, 250, 20) title:nil font:14];
    phone.textColor = [UIColor lightGrayColor];
    [firstView addSubview:phone];
    email = [MyControll createLabelWithFrame:CGRectMake(20, 100, 250, 20) title:nil font:14];
    email.textColor = [UIColor lightGrayColor];
    [firstView addSubview:email];
    weichat = [MyControll createLabelWithFrame:CGRectMake(20, 120, 250, 20) title:nil font:14];
    weichat.textColor = [UIColor lightGrayColor];
    [firstView addSubview:weichat];
    [self RefreshUI];
 
    UIImageView *secView = [MyControll createImageViewWithFrame:CGRectMake(0, 160, WIDTH, 50) imageName:@"白背景"];
    [mainSC addSubview:secView];
    
    UILabel *xiangceLabel = [MyControll createLabelWithFrame:CGRectMake(20, 0, WIDTH-20, 50) title:@"相册" font:16];
    [secView addSubview:xiangceLabel];
    
    UIButton *xiangceBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(GoToXiangce) target:self];
    [secView addSubview:xiangceBtn];
    
    
    
    UIImageView *thirdView = [MyControll createImageViewWithFrame:CGRectMake(0, 220, WIDTH, 50) imageName:@"白背景"];
    [mainSC addSubview:thirdView];
    
    UILabel *dongtaiLabel = [MyControll createLabelWithFrame:CGRectMake(20, 0, 200, 50) title:@"动态" font:16];
    [thirdView addSubview:dongtaiLabel];
    
    UILabel *congtaiCount = [MyControll createLabelWithFrame:CGRectMake(WIDTH - 70, 0, 40, 50) title:@"56条" font:15];
    congtaiCount.text = [NSString stringWithFormat:@"%@条",self.dataDic[@"tnum"]];
    congtaiCount.textColor = [UIColor colorWithRed:102.0/256 green:122.0/256 blue:166.0/256 alpha:1];
    [thirdView addSubview:congtaiCount];
    
    
    UILabel *gerenbqLabel = [MyControll createLabelWithFrame:CGRectMake(20, 290, 200, 20) title:@"个人标签" font:15];
    [mainSC addSubview:gerenbqLabel];
    
    UIButton *addBiaoqian = [MyControll createButtonWithFrame:CGRectMake(WIDTH - 100, 290, 80, 20) bgImageName:nil imageName:nil title:@"给他贴标签" selector:@selector(addBiaoqian) target:self];
    [addBiaoqian setTitleColor:[UIColor colorWithRed:102.0/256 green:122.0/256 blue:166.0/256 alpha:1] forState:UIControlStateNormal];
    addBiaoqian.titleLabel.font = [UIFont systemFontOfSize:14];
    [mainSC addSubview:addBiaoqian];
    
    fourView = [MyControll createViewWithFrame:CGRectMake(0, 320, WIDTH, 70)];
    fourView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:fourView];
    
    [self dealBiaoqian];
    
    
    jingliLabel = [MyControll createLabelWithFrame:CGRectMake(20, fourView.frame.origin.y +fourView.frame.size.height +20, 200, 20) title:@"经历" font:15];
    [mainSC addSubview:jingliLabel];
    
    fifthView = [MyControll createViewWithFrame:CGRectMake(0, jingliLabel.frame.origin.y+jingliLabel.frame.size.height + 20, WIDTH, 80)];
    fifthView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:fifthView ];
    
    CGSize sizeOfComment =[MyControll getSize:self.dataDic[@"text"] Font:14 Width:WIDTH-40 Height:1000];
    
    jingliDesc = [MyControll createLabelWithFrame:CGRectMake(20, 10, WIDTH - 40, sizeOfComment.height+10) title:self.dataDic[@"Text"] font:14];
    jingliDesc.textColor = [UIColor lightGrayColor];
    [fifthView addSubview:jingliDesc];
    
    fifthView.frame = CGRectMake(0, jingliLabel.frame.origin.y+jingliLabel.frame.size.height+20, WIDTH, 10+jingliDesc.frame.size.height+10);
    
    commentLabel = [MyControll createLabelWithFrame:CGRectMake(20, fifthView.frame.origin.y+fifthView.frame.size.height+20, 200, 20) title:@"评论" font:15];
    [mainSC addSubview:commentLabel];
    
    
    sixthView = [MyControll createViewWithFrame:CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height +10, WIDTH, 260)];
    sixthView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:sixthView];
    
    bottomView = [MyControll createViewWithFrame:CGRectMake(0, 10, WIDTH, 30)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [sixthView addSubview:bottomView];
    zanBtn = [MyControll createButtonWithFrame:CGRectMake(20, 0, 20, 30) bgImageName:nil imageName:@"31" title:nil selector:@selector(btnClick:) target:self];
    [bottomView addSubview:zanBtn];
    zanBtn.tag = 102;
    zanCount = [MyControll createLabelWithFrame:CGRectMake(45, 0, 30, 30) title:nil font:13];
    zanCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:zanCount];
    
    shareBtn = [MyControll createButtonWithFrame:CGRectMake(135, 0, 20, 30) bgImageName:nil imageName:@"32" title:nil selector:@selector(btnClick:) target:self];
    shareBtn.tag = 103;
    [bottomView addSubview:shareBtn];
    shareCount = [MyControll createLabelWithFrame:CGRectMake(160, 0, 30, 30) title:nil font:13];
    shareCount.textColor = [UIColor lightGrayColor];
    
    [bottomView addSubview:shareCount];
    
    commentBtn = [MyControll createButtonWithFrame:CGRectMake(250, 0, 20, 30) bgImageName:nil imageName:@"33" title:nil selector:@selector(btnClick:) target:self];
    [bottomView addSubview:commentBtn];
    commentBtn.tag = 104;
    commentCount = [MyControll createLabelWithFrame:CGRectMake(275, 0, 20, 30) title:nil font:13];
    commentCount.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:commentCount];
    
    
    [self commentView];
    
}
-(void)GoToXiangce
{
    PhotoCheckViewController *vc =[[PhotoCheckViewController alloc]init];
    vc.picArray = self.dataDic[@"image"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)commentView
{
     zanCount.text = self.dataDic[@"anum"];
     shareCount.text = self.dataDic[@"snum"];
     commentCount.text = self.dataDic[@"cnum"];
    
//    if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"0"]) {
        [zanBtn setImage:[UIImage imageNamed:@"31"] forState:UIControlStateNormal];
//    }
//    else if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"1"])
//    {
//        [zanBtn setImage:[UIImage imageNamed:@"411"] forState:UIControlStateNormal];
//    }
    NSArray *shareArray = self.dataDic[@"share"];
    NSArray *commentArray = self.dataDic[@"comments"];
    NSArray *zanArray = self.dataDic[@"approval"];
    if (shareArray.count>0||commentArray.count>0||zanArray.count>0) {
        commentDetailView = [MyControll createImageViewWithFrame:CGRectMake(10, 300, WIDTH - 20, 200) imageName:@"67"];
        commentDetailView.userInteractionEnabled = YES;
        [sixthView addSubview:commentDetailView];
        float height = 5;
        if (zanArray.count>0) {
            UIView *zanView = [MyControll createViewWithFrame:CGRectMake(0, height, commentDetailView.frame.size.width, 20)];
            [commentDetailView addSubview:zanView];
            UIImageView *zan = [MyControll createImageViewWithFrame:CGRectMake(10, 0, 20, 20) imageName:@"68"];
            zan.contentMode = UIViewContentModeCenter;
            [zanView addSubview:zan];
            float width = 0;
            for (int i = 0; i<zanArray.count; i++) {
                if (width<WIDTH -75) {
                    NSDictionary *dic = zanArray[i];
                    CGSize size = [MyControll getSize:dic[@"name"] Font:13 Width:100 Height:20];
                    UIButton *nameBtn = [MyControll createButtonWithFrame:CGRectMake(35+width, 0, size.width+5, 20) bgImageName:nil imageName:nil title:dic[@"name"] selector:@selector(zanNameClick:) target:self];
                    nameBtn.tag = 400+i;
                    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [nameBtn setTitleColor:[UIColor colorWithRed:0.46f green:0.53f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
                    [zanView addSubview:nameBtn];
                    width = width+size.width+10;
                }
            }
            height = height + 25;
        }
        
        
        if (shareArray.count>0) {
            UIView *shareView = [MyControll createViewWithFrame:CGRectMake(0, height, commentDetailView.frame.size.width, 25)];
            [commentDetailView addSubview:shareView];
            UIImageView *share = [MyControll createImageViewWithFrame:CGRectMake(10, 0, 20, 20) imageName:@"69"];
            share.contentMode = UIViewContentModeCenter;
            [shareView addSubview:share];
            float width = 0;
            for (int i = 0; i<shareArray.count; i++) {
                if (width<WIDTH -75) {
                    NSDictionary *dic = shareArray[i];
                    CGSize size = [MyControll getSize:dic[@"name"] Font:13 Width:100 Height:20];
                    UIButton *nameBtn = [MyControll createButtonWithFrame:CGRectMake(35+width, 0, size.width+5, 20) bgImageName:nil imageName:nil title:dic[@"name"] selector:@selector(shareNameClick:) target:self];
                    nameBtn.tag = 400+i;
                    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [nameBtn setTitleColor:[UIColor colorWithRed:0.46f green:0.53f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
                    [shareView addSubview:nameBtn];
                    width = width+size.width+10;
                }
            }
            height = height + 25;
        }
        
        
        if (commentArray.count>0) {
            UIView *commentView = [MyControll createViewWithFrame:CGRectMake(0, height, commentDetailView.frame.size.width, 1000)];
            [commentDetailView addSubview:commentView];
            UIImageView *comment = [MyControll createImageViewWithFrame:CGRectMake(10, 0, 20, 20) imageName:@"70"];
            comment.contentMode = UIViewContentModeCenter;
            [commentView addSubview:comment];
            float cHeight = 0;
            for (int i = 0; i<commentArray.count; i++) {
                NSDictionary *dic = commentArray[i];
                CGSize size = [MyControll getSize:dic[@"name"] Font:13 Width:100 Height:20];
                UIButton *nameBtn = [MyControll createButtonWithFrame:CGRectMake(35, cHeight, size.width+10, 20) bgImageName:nil imageName:nil title:[NSString stringWithFormat:@"%@:",dic[@"name"]] selector:@selector(commentNameClick:) target:self];
                nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                nameBtn.tag = 400+i;
                [nameBtn setTitleColor:[UIColor colorWithRed:0.46f green:0.53f blue:0.68f alpha:1.00f] forState:UIControlStateNormal];
                [commentView addSubview:nameBtn];
                CGSize contentSize = [MyControll getSize:dic[@"text"] Font:13 Width:WIDTH-20-35-size.width-10-5 Height:1000];
                UILabel *contentLabel = [MyControll createLabelWithFrame:CGRectMake(35 +size.width +15, cHeight, WIDTH-15-35-size.width-10-5, contentSize.height +7) title:dic[@"text"] font:13];
                [commentView addSubview:contentLabel];
                cHeight = cHeight + contentSize.height +7;
            }
            height = height + cHeight;
        }
        
        commentDetailView.frame = CGRectMake(10, bottomView.frame.origin.y + 30 + 10, WIDTH-20, height+5);
        sixthView.frame = CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height + 10, WIDTH, commentDetailView.frame.origin.y+commentDetailView.frame.size.height+10);
    }
    else
    {
        sixthView.frame = CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height + 10, WIDTH, 10+30+10);
    }
     mainSC.contentSize = CGSizeMake(WIDTH, sixthView.frame.origin.y+sixthView.frame.size.height+10);
}
-(void)zanNameClick:(UIButton *)sender
{
    
}
-(void)shareNameClick:(UIButton *)sender
{
    
}
-(void)commentNameClick:(UIButton *)sender
{
    
}
-(void)RefreshUI
{
    if ([[self.dataDic[@"flag"] stringValue] isEqualToString:@"1"]||[[self.dataDic[@"flag"]stringValue] isEqualToString:@"2"]) {
        phone.text = [NSString stringWithFormat:@"手机：%@",self.dataDic[@"mobile"]];
        email.text =[NSString stringWithFormat:@"邮箱：%@",self.dataDic[@"email"]];
        weichat.text=[NSString stringWithFormat:@"微信：%@",self.dataDic[@"wei"]];
    }
    else
    {
        phone.text = [NSString stringWithFormat:@"手机：%@",@"仅好友可见"];
        email.text =[NSString stringWithFormat:@"邮箱：%@",@"仅好友可见"];
        weichat.text=[NSString stringWithFormat:@"微信：%@",@"仅好友可见"];
    }

}
-(void)dealBiaoqian
{
    for (UIView *view in fourView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *biaoqianArray = self.dataDic[@"tags"];
    float width = 0;
    if (biaoqianArray.count>0) {
        for (int i = 0; i<biaoqianArray.count + 1; i++) {
            if (i<biaoqianArray.count) {
                NSString *str =biaoqianArray[i][@"name"];
                CGSize size = [MyControll getSize:str Font:13 Width:90 Height:20];
                if (i%3 == 0) {
                    width = 0;
                }
                UIButton *bqBtn = [MyControll createButtonWithFrame:CGRectMake(20 + width, 15+(i/3)*40, size.width + 30, 30) bgImageName:nil imageName:nil title:[NSString stringWithFormat:@"%@  %@",str,biaoqianArray[i][@"num"]] selector:@selector(bqBtnClick:) target:self];
                bqBtn.tag = 10000 + i;
                bqBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                bqBtn.clipsToBounds = YES;
                bqBtn.layer.cornerRadius = 2;
                [bqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [bqBtn setBackgroundColor:[UIColor colorWithRed:0.20f green:0.50f blue:0.84f alpha:1.00f]];
                [fourView addSubview:bqBtn];
                width = width + size.width + 40;
            }
            else
            {
                if (i%3 == 0) {
                    width = 0;
                }
                UIButton *addbtn = [MyControll createButtonWithFrame:CGRectMake(20+width, 15+(i/3)*40, 60, 30) bgImageName:nil imageName:@"添加" title:nil selector:@selector(addBiaoqian) target:self];
                [fourView addSubview:addbtn];
                
            }
        }
    }
    else
    {
        UIButton *addbtn = [MyControll createButtonWithFrame:CGRectMake(20, 15, 60, 30) bgImageName:nil imageName:@"添加" title:nil selector:@selector(addBiaoqian) target:self];
        [fourView addSubview:addbtn];
    }
    
    if (biaoqianArray.count>0) {
        int row = (int)(biaoqianArray.count + 1)/3+1;
        if ((biaoqianArray.count + 1)%3 == 0) {
            row = row-1;
        }
        fourView.frame = CGRectMake(0, 320, WIDTH, 20 + 20 + row * 30 + (row-1)*10);
        
        
        jingliLabel.frame=CGRectMake(20, fourView.frame.origin.y +fourView.frame.size.height +20, 200, 20);
        CGSize sizeOfComment =[MyControll getSize:self.dataDic[@"text"] Font:14 Width:WIDTH-40 Height:1000];
        jingliDesc.frame = CGRectMake(20, 10, WIDTH - 40, sizeOfComment.height+10);
        fifthView.frame = CGRectMake(0, jingliLabel.frame.origin.y+jingliLabel.frame.size.height+20, WIDTH, 10+jingliDesc.frame.size.height+10);
        commentLabel.frame =CGRectMake(20, fifthView.frame.origin.y+fifthView.frame.size.height+20, 200, 20);
        
        NSArray *shareArray = self.dataDic[@"share"];
        NSArray *commentArray = self.dataDic[@"comments"];
        NSArray *zanArray = self.dataDic[@"approval"];
        
        if (shareArray.count>0||commentArray.count>0||zanArray.count>0) {
        sixthView.frame = CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height + 10, WIDTH, commentDetailView.frame.origin.y+commentDetailView.frame.size.height+10);
    
        }
        else
        {
        sixthView.frame = CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height + 10, WIDTH, 10+30+10);
        }
        mainSC.contentSize = CGSizeMake(WIDTH, sixthView.frame.origin.y+sixthView.frame.size.height+10);
    }
    else
    {
        fourView.frame = CGRectMake(0, 320, WIDTH, 70);
        
        jingliLabel.frame=CGRectMake(20, fourView.frame.origin.y +fourView.frame.size.height +20, 200, 20);
        CGSize sizeOfComment =[MyControll getSize:self.dataDic[@"text"] Font:14 Width:WIDTH-40 Height:1000];
        jingliDesc.frame = CGRectMake(20, 10, WIDTH - 40, sizeOfComment.height+10);
        fifthView.frame = CGRectMake(0, jingliLabel.frame.origin.y+jingliLabel.frame.size.height+20, WIDTH, 10+jingliDesc.frame.size.height+10);
        commentLabel.frame =CGRectMake(20, fifthView.frame.origin.y+fifthView.frame.size.height+20, 200, 20);
        
        NSArray *shareArray = self.dataDic[@"share"];
        NSArray *commentArray = self.dataDic[@"comments"];
        NSArray *zanArray = self.dataDic[@"approval"];
        
        if (shareArray.count>0||commentArray.count>0||zanArray.count>0) {
            sixthView.frame = CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height + 10, WIDTH, commentDetailView.frame.origin.y+commentDetailView.frame.size.height+10);
            
        }
        else
        {
            sixthView.frame = CGRectMake(0, commentLabel.frame.origin.y +commentLabel.frame.size.height + 10, WIDTH, 10+30+10);
        }
        mainSC.contentSize = CGSizeMake(WIDTH, sixthView.frame.origin.y+sixthView.frame.size.height+10);
    }

}
-(void)bqBtnClick:(UIButton *)senser
{
    int index = (int)senser.tag - 10000;
    NSArray *biaoqianArray = self.dataDic[@"tags"];
    biaoqianContent = biaoqianArray[index][@"name"];
    [self addBiaoqianCommit];
}
-(void)addBiaoqian
{
    UIView *view = [MyControll createViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT +64 + 49)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.tag = 999;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.tabBarController.view addSubview:view];
    UIView * bgView = [MyControll createViewWithFrame:CGRectMake(10, 80, WIDTH - 20, 190)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.tag = 998;
    [self.tabBarController.view addSubview:bgView];
    
    UILabel *tishiLabel = [MyControll createLabelWithFrame:CGRectMake(20, 20, 100, 20) title:@"给TA贴标签" font:14];
    tishiLabel.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    [bgView addSubview:tishiLabel];
    biaoqianTX = [MyControll createTextFieldWithFrame:CGRectMake(20, 60, bgView.frame.size.width - 40, 40) text:nil placehold:nil font:14];
    biaoqianTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [biaoqianTX becomeFirstResponder];
    biaoqianTX.layer.borderWidth = 1;
    [bgView addSubview:biaoqianTX];
    
    UIButton *addCancleBtn  = [MyControll createButtonWithFrame:CGRectMake(20, 120, 110, 40) bgImageName:nil imageName:@"quxiao" title:nil selector:@selector(addClick:) target:self];
    addCancleBtn.tag = 600;
    addCancleBtn.clipsToBounds = YES;
    addCancleBtn.layer.cornerRadius = 3;
    [bgView addSubview:addCancleBtn];
    
    UIButton *addConfirmBtn = [MyControll createButtonWithFrame:CGRectMake(bgView.frame.size.width - 130, 120, 110, 40) bgImageName:nil imageName:@"queding" title:nil selector:@selector(addClick:) target:self];
    addConfirmBtn.tag = 601;
    addConfirmBtn.layer.cornerRadius = 3;
    addConfirmBtn.clipsToBounds = YES;
    [bgView addSubview:addConfirmBtn];
    
}
-(void)addClick:(UIButton *)sender
{
    if (sender.tag == 601) {
        if (biaoqianTX.text.length == 0) {
            [self showMsg:@"标签不能为空"];
        }
        else if (biaoqianTX.text.length >8) {
            [self showMsg:@"标签字符不能超过8个字"];
        }
        else
        {
            biaoqianContent = biaoqianTX.text;
            [self addBiaoqianCommit];
            [self tap:nil];
        }
    }
    else
    {
        [self tap:nil];
    }
}
-(void)tap:(UIGestureRecognizer *)sender
{
    UIView *view = [self.tabBarController.view viewWithTag:999];
    [view removeFromSuperview];
    UIView *bgView = [self.tabBarController.view viewWithTag:998];
    for (UIView *view in bgView.subviews) {
        [view removeFromSuperview];
    }
    [bgView removeFromSuperview];
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag - 100;
    
    
}

#pragma mark  创建bView
-(void)createbView
{
    UIImageView *bView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT - 60, WIDTH, 60) imageName:@"51"];
    bView.userInteractionEnabled = YES;
    bView.alpha = 0.9;
    [self.view addSubview:bView];
    
    UIButton *sendMegBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-120)/2, 0, 120, 60) bgImageName:nil imageName:@"发消息" title:nil selector:@selector(bottomClick:) target:self];
    sendMegBtn.tag = 20;
    [bView addSubview:sendMegBtn];
    
    
    UIButton *addFriendBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2 - 120)/2+WIDTH/2, 0, 120, 60) bgImageName:nil imageName:@"加好友" title:nil selector:@selector(bottomClick:) target:self];
    addFriendBtn.tag = 21;
    [bView addSubview:addFriendBtn];
}
-(void)createbView1
{
    UIImageView *bView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT - 60, WIDTH, 60) imageName:@"51"];
    bView.userInteractionEnabled = YES;
    bView.alpha = 0.9;
    [self.view addSubview:bView];
    
    UIButton *sendMegBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-120)/2, 0, 120, 60) bgImageName:nil imageName:@"发消息" title:nil selector:@selector(bottomClick:) target:self];
    sendMegBtn.tag = 22;
    [bView addSubview:sendMegBtn];
    
    
    UIButton *addFriendBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2 - 120)/2+WIDTH/2, 0, 120, 60) bgImageName:nil imageName:@"存入通讯录@2x" title:nil selector:@selector(bottomClick:) target:self];
    addFriendBtn.tag = 23;
    [bView addSubview:addFriendBtn];
}
-(void)createbView2
{
    UIImageView *bView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT - 60, WIDTH, 60) imageName:@"51"];
    bView.userInteractionEnabled = YES;
    bView.alpha = 0.9;
    [self.view addSubview:bView];
    
    UIButton *sendMegBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-120)/2, 0, 120, 60) bgImageName:nil imageName:@"发消息" title:nil selector:@selector(bottomClick:) target:self];
    sendMegBtn.tag = 24;
    [bView addSubview:sendMegBtn];
    
}
-(void)bottomClick:(UIButton *)sender
{
    if (sender.tag == 20||sender.tag == 24||sender.tag == 22) {
        SendMessageViewController *vc = [[SendMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tid = self.dataDic[@"id"];
        vc.name = self.dataDic[@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 21)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您想加他/她为好友吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2000000;
        [alertView show];
    }
    else if (sender.tag == 23)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您想将他/她的电话存入通讯录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2000001;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2000000 ) {
        if (buttonIndex == 1) {
            [self addFriendCommit];
        }
    }
   else if(alertView.tag == 2000001)
   {
       if (buttonIndex == 1) {
           CFErrorRef error = NULL;
           ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, &error);
           ABRecordRef newPerson = ABPersonCreate();
           ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.dataDic[@"name"]), &error);
           
           //phone number
           ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
           ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(self.dataDic[@"mobile"]), kABPersonPhoneHomeFAXLabel, NULL);
           ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(self.dataDic[@"mobile"]), kABPersonPhoneMobileLabel, NULL);
           ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
           CFRelease(multiPhone);
           
           ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
           ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(self.dataDic[@"email"]), kABWorkLabel, NULL);
           ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
           CFRelease(multiEmail);
           
           NSData *dataRef = UIImagePNGRepresentation(headView.image);
           ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, &error);
           
           ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
           ABAddressBookSave(iPhoneAddressBook, &error);
           CFRelease(newPerson);
           CFRelease(iPhoneAddressBook);
           [self showMsg:@"添加到通讯录成功"];
       }
   }
}
-(void)addFriendCommit
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    //    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"%@addfriends?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,self.dataDic[@"id"]];
    self.secDownManager= [[ImageDownManager alloc]init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}
-(void)OnLoadFinish1:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict.count>0&&[dict isKindOfClass:[NSDictionary class]]&&dict) {
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"1"]) {
            [self showMsg:@"申请加好友成功"];
        
        }
        else
        {
            [self showMsg:@"申请加好友失败"];
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
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *urlstr = [NSString stringWithFormat:@"%@otherinfo?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_uid];
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
    if (dict&&[dict isKindOfClass:[NSDictionary class]]&&dict.count>0) {
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [self makeUI];
        if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"0"]) {
            [self createbView];
        }
        else if ([[self.dataDic[@"flag"] stringValue]isEqualToString:@"1"])
        {
            [self createbView1];
        }
        else
        {
            [self createbView2];
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}
#pragma mark  添加标签
-(void)addBiaoqianCommit
{
    if (_thirdDownManager) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@createtag?uid=%@&token=%@&tid=%@&tag=%@",SERVER_URL,uid,token,_uid,biaoqianContent];
    self.thirdDownManager= [[ImageDownManager alloc]init];
    _thirdDownManager.delegate = self;
    _thirdDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManager.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManager GetImageByStr:urlstr];
    
}
-(void)OnLoadFinish2:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel2];
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.count>0) {
        if ([[dict[@"code"]stringValue]isEqualToString:@"1"]) {
            NSMutableArray *biaoqianArray = self.dataDic[@"tags"];
            for (NSMutableDictionary *dic in biaoqianArray) {
                if ([dic[@"name"]isEqualToString:biaoqianContent]) {
                    [dic setObject:[NSString stringWithFormat:@"%d",[dic[@"num"] intValue]+1] forKey:@"num"];
                    [self dealBiaoqian];
                    return;
                }
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setObject:@"0" forKey:@"num"];
            [dic setObject:biaoqianContent forKey:@"name"];
            [biaoqianArray addObject:dic];
            [self dealBiaoqian];
        }
    }
    else if(dict.count == 0)
    {
        
    }
    
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.thirdDownManager);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
