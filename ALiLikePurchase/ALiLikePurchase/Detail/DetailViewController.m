//
//  DetailViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "DetailViewController.h"
#import "GoodsDetailView.h"
#import "GoodsModel.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailBottomView.h"
#import "RootViewController.h"
#import "PassWordToBuyView.h"
#import "CreateShareViewController.h"
#import "DBManager.h"
#import "InstallmentWebViewController.h"
#import "LoginViewController.h"

@interface DetailViewController ()<GoodsDetailBottomViewDelegate, GoodsDetailViewDelegate>

@property(nonatomic, strong)GoodsDetailView *detailView;

@property(nonatomic, strong)GoodsDetailBottomView *detailBottomView;

@property(nonatomic, strong)GoodsDetailModel *detailModel;

@property(nonatomic, strong)PassWordToBuyView *passwordBuyView;

@property(nonatomic, strong)UIView *backView;

@property(nonatomic, copy)NSString *shareString;

@property(nonatomic, assign)BOOL isfavorite;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.detailView];
    [self.view addSubview:self.detailBottomView];
    [self.view addSubview:self.passwordBuyView];
    [self.view addSubview:self.backView];
    [self.passwordBuyView setHidden:YES];
}

-(void)initData{
    
    User *user = [[DataManager shareInstance]getUser];
    NSString *appToken = user.appToken;
    
    if(self.model != nil){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.model.numIid forKey:@"mid"];
        
        [dic setObject:@"ios" forKey:@"deviceOs"];
        
        if (appToken != nil) {
            [dic setObject:appToken forKey:@"appToken"];
        }
        
        if(self.model.rebateAmount != nil){
            [dic setObject:self.model.rebateAmount forKey:@"rebateAmount"];
        }
        
        
        [[DataManager shareInstance]getGoodsDetailsParame:dic callBack:^(NSObject *object) {
            
            if ([object isKindOfClass:[Message class]] == YES) {
                NSLog(@"Message");
                Message *model = (Message *)object;
                NSInteger code = [model.code integerValue];
                
                if (code == 1) {
                    InstallmentWebViewController *webVC = [[InstallmentWebViewController alloc]init];
                    [self.navigationController pushViewController:webVC animated:YES];
                }else{
                    LoginViewController *login = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                }
            }else{
                self.detailModel = (GoodsDetailModel *)object;
                self.detailModel.itemDescription = self.model.itemDescription;
                self.detailModel.sellerId = self.model.sellerId;
                self.detailModel.title = self.model.title;
                self.detailModel.rebateAmount = self.model.rebateAmount;
                self.detailModel.numIid = self.model.numIid;
                self.detailModel.pictUrl = self.model.pictUrl;
                self.detailModel.goodsModel = self.model;
                
                
                if (self.detailModel.shopTitle.length == 0) {
                    self.detailModel.shopTitle = self.model.shopTitle;
                }
                
                if (self.detailModel.smallImages == nil) {
                    self.detailModel.smallImages = self.model.smallImages;
                }
                
                if (self.detailModel.userType.length == 0) {
                    self.detailModel.userType = self.model.userType;
                }
                
                if (self.detailModel.volume.length == 0) {
                    self.detailModel.volume = self.model.volume;
                }
                
                if (self.detailModel.nick.length == 0) {
                    self.detailModel.nick = self.model.nick;
                }
                
                [self.detailView setModel:self.detailModel];
                
                NSDictionary *shopDic = @{@"appToken":appToken, @"mid":self.detailModel.numIid, @"model": self.detailModel};
                
                [[DataManager shareInstance]getGoodsShopDetail:shopDic callBack:^(NSObject *object) {
                    self.detailModel = (GoodsDetailModel *)object;
                    
                    [[DBManager shareInstance]writeData:self.detailModel];
                    
                    [self.detailView setModel:self.detailModel];
                }];
                
                
                
                NSDictionary *dic = @{@"appToken":appToken, @"mid":self.detailModel.numIid};
                [[DataManager shareInstance]goodsIsFavorite:dic callBack:^(Message *message) {
                    if (message.isSuccess == YES) {
                        self.isfavorite = YES;
                    }else{
                        self.isfavorite = NO;
                    }
                }];
            }
        }];
    }
}

#pragma mark -  GoodsDetailViewDelegate
-(void)tapGoodsInfoView{
    [self.passwordBuyView setLinkString:self.shareString];
    [self.passwordBuyView setHidden:NO];
}

#pragma mark - GoodsDetailBottomViewDelegate
-(void)tapCollection{
    
    NSLog(@"tapCollection");
    
    User *user = [[DataManager shareInstance]getUser];
    NSDictionary *dic;
    if (self.isfavorite == YES) {
         dic = @{@"appToken":user.appToken, @"favStatus":@"2", @"mid":self.detailModel.numIid};
    }else{
         dic = @{@"appToken":user.appToken, @"favStatus":@"1", @"mid":self.detailModel.numIid};
    }
    [[DataManager shareInstance]goodsFavorite:dic callBack:^(Message *message) {
        Message *model = message;
        if ([[NSString stringWithFormat:@"%@",model.code] isEqualToString:@"0"] == YES) {
            self.isfavorite = !self.isfavorite;
        }
    }];
}

-(void)jumpHomePage{
    NSLog(@"jumpHomePage");
    [self.tabBarController.tabBar setHidden:NO];
    RootViewController *vc = (RootViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    vc.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)tapBuy{
    NSLog(@"tapBuy");
    
    [self.passwordBuyView setLinkString:self.shareString];
    [self.passwordBuyView setHidden:NO];
}

-(void)tapShare{
    NSLog(@"tapShare");
    
    CreateShareViewController *createShare = [[CreateShareViewController alloc]init];
    createShare.model = self.detailModel;
    createShare.shareString = self.shareString;
    [self.navigationController pushViewController:createShare animated:YES];
}

#pragma mark - action
-(void)backAction{
    if (self.isHomePage == YES) {
        [self.tabBarController.tabBar setHidden:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter / getter
-(GoodsDetailView *)detailView{
    if (_detailView == nil) {
//        CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? [[UIApplication sharedApplication] statusBarFrame].size.height : 0;
        _detailView = [[GoodsDetailView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - BOTTOM_MARGIN_HEIGHT)];
        [_detailView setDelegate:self];
    }
    return _detailView;
}

-(GoodsDetailBottomView *)detailBottomView{
    if (_detailBottomView == nil) {
        _detailBottomView = [[GoodsDetailBottomView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.detailView.frame), ScreenWidth, 49)];
        [_detailBottomView setDelegate:self];
    }
    return _detailBottomView;
}

-(UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(9,self.detailView.mj_y, 100, 100)];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"fang"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:_backView.bounds];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
        [_backView addSubview:button];
    }
    return _backView;
}

-(PassWordToBuyView *)passwordBuyView{
    if (_passwordBuyView == nil) {
        _passwordBuyView = [[PassWordToBuyView alloc]initWithFrame:self.view.bounds];
        
    }
    return _passwordBuyView;
}

-(NSString *)shareString{
    NSString *str = [NSString stringWithFormat:@"%@\n%@\n【折扣价】%@元\n【券后价】%@元\n【下载地址】http://wx.alhuigou.com\n-----------------\n长按復·制这段描述，%@，打开【📱taobao】即可抢购",self.detailModel.title,self.detailModel.itemDescription,self.detailModel.zkFinalPrice,self.detailModel.couponAfterPrice,self.detailModel.couponTpwd];
    return str;
}

-(void)setIsfavorite:(BOOL)isfavorite{
    _isfavorite = isfavorite;
     [self.detailBottomView setIsfavorite:isfavorite];
}

@end
