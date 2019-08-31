//
//  InviteViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "InviteViewController.h"
#import "CWActionSheet.h"
#import "ShareModel.h"
#import "NavigationView.h"

#import "UIImage+Tool.h"

@interface InviteViewController ()<NavigationViewDelegate>

@property(nonatomic, strong)UIImageView *imageView;

@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)UILabel *yaoqingLabel;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.contentView];
    
//    [self.contentView setFrame:self.view.bounds];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongChick:)];
    
    [self.contentView addGestureRecognizer:longPress];
    
    [self.navigationView setTitle:@"邀请"];
}

-(void)initData{
    User *user = [[DataManager shareInstance]getUser];
    if (user != nil) {
        [self.yaoqingLabel setText:[NSString stringWithFormat:@"邀请码：%@",user.selfResqCode]];
        
       CGFloat width =  [self getWidthWithText:self.yaoqingLabel.text height:35 font:17] +25;
        
       self.yaoqingLabel.mj_x = (ScreenWidth - width)/2;
        self.yaoqingLabel.mj_w = width;
        self.yaoqingLabel.layer.cornerRadius = 8;
        self.yaoqingLabel.layer.masksToBounds = YES;
    }
}

-(void)share:(NSInteger)number{
    UIImage *temp = [UIImage snapshotWithView:self.contentView];
    UIImage *img = [UIImage compressImage:temp toByte:32768];
     NSData *imageData = [UIImage newCompressImage:img toByte:32760];
    
    if (number == 0) {
        NSLog(@"点击了分享到朋友圈");
        [ShareModel shareToWeChatToTimeline:imageData];
    }else{
        NSLog(@"点击了分享邀请海报");
        [ShareModel shareToWeChatToSession:imageData];
    }
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat )font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}

#pragma mark - action

-(void)LongChick:(UILongPressGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSArray *title = @[@"分享到朋友圈", @"分享邀请海报"];
        CWActionSheet *sheet = [[CWActionSheet alloc] initWithTitles:title clickAction:^(CWActionSheet *sheet, NSIndexPath *indexPath) {
            [self share:indexPath.row];
        }];
        [sheet show];
    }
}

#pragma mark - NavigationViewDelegate

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - getter/setter
-(UIImageView *)imageView{
    if(_imageView == nil){
        
        UIImage *image = [UIImage imageCompressForWidth:[UIImage imageNamed:@"WechatIMG19"] targetWidth:ScreenWidth];
        
        _imageView = [[UIImageView alloc]initWithImage:image];
        [_imageView setUserInteractionEnabled:YES];
        
        [_imageView setContentMode:UIViewContentModeTop];
    }
    return _imageView;
}


-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(void)setIsPush:(BOOL)isPush{
    _isPush = isPush;
    if (isPush == YES) {
        [self.view addSubview:self.navigationView];
        [self.contentView setFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationView.frame))];
    }
}

-(UIView *)contentView{
    if (_contentView == nil) {
        CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, height, ScreenWidth, ScreenHeight - height)];
        [_contentView addSubview:self.imageView];
        [self.imageView setFrame:_contentView.bounds];
        
        
        [_contentView addSubview:self.yaoqingLabel];
        
        [self.yaoqingLabel setCenter:_contentView.center];
    }
    return _contentView;
}

-(UILabel *)yaoqingLabel{
    if (_yaoqingLabel == nil) {
        _yaoqingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        
        [_yaoqingLabel setBackgroundColor:[UIColor whiteColor]];
        [_yaoqingLabel setTextAlignment:NSTextAlignmentCenter];
        
        
    }
    return _yaoqingLabel;
}

@end
