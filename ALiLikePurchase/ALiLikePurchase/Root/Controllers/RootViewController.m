//
//  RootViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "RootViewController.h"

#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "InviteViewController.h"
#import "UserCenterViewController.h"
#import "WantBuyView.h"
#import "WantBuyModel.h"

#import "GoodsModel.h"

#import "DetailViewController.h"

@interface RootViewController ()<WantBuyViewDelegate>

@property(nonatomic, strong)WantBuyView *buyView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载数据
    [self initData];
    //初始化框架
    [self initNavigationControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taobaoCommand) name:NOTIFICATIONCOPYTEXT object:nil];
}

#pragma mark - methods

-(void)initData{
    User *user = [[DataManager shareInstance]getUser];
    if (user != nil) {
        [[DataManager shareInstance]getCustomerInfo:@{@"appToken":user.appToken} callBack:^(NSObject *object) {}];
    }
}

-(void)initNavigationControllers{
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    UINavigationController * homeNav = [self createNavigationController:homeVC title:@"首页" imagePic:@"homepage" selecedImagePic:@"homepage_fill"];
    [viewControllers addObject:homeNav];
    
    CategoryViewController *categoryVC = [[CategoryViewController alloc]init];
    UINavigationController * categoryNav = [self createNavigationController:categoryVC title:@"分类" imagePic:@"manage2" selecedImagePic:@"manage_fill"];
    [viewControllers addObject:categoryNav];
    
    InviteViewController *invityVC = [[InviteViewController alloc]init];
    UINavigationController * invityNav = [self createNavigationController:invityVC title:@"邀请" imagePic:@"integral2"selecedImagePic:@"integral_fill"];
    [viewControllers addObject:invityNav];
    
    UserCenterViewController *userVC = [[UserCenterViewController alloc]init];
    UINavigationController * userNav = [self createNavigationController:userVC title:@"我的" imagePic:@"mine2" selecedImagePic:@"mine_fill"];
    [viewControllers addObject:userNav];
    
    self.viewControllers = viewControllers;
    

//    [self taobaoCommand];
}

-(UINavigationController *)createNavigationController:(UIViewController *)controller title:(NSString *)title imagePic:(NSString *)pic selecedImagePic:(NSString *)selectPic{
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:controller];
    
    UIImage * picImage = [UIImage imageNamed:selectPic];
    
    nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:picImage selectedImage:[UIImage imageNamed:selectPic]];
   
    picImage = [picImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [nav.tabBarItem setSelectedImage:picImage];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:RGB(251, 87, 84) forKey:NSForegroundColorAttributeName];
    
    [nav.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    return nav;
}

-(void)taobaoCommand{
    
    NSString *shareStr = [UIPasteboard generalPasteboard].string;

    if (shareStr != nil && shareStr.length > 0) {
        NSArray *list = [self filterString:shareStr];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < list.count; i ++) {
            NSString *item = list[i];
            BOOL flag = [self isHasChineseChar:item];
            if (flag == NO) {
                [tempArray addObject:item];
            }
        }
        
        if (tempArray.count == 1) {
            NSString *str = [tempArray lastObject];
            [[DataManager shareInstance]queryTKL:@{@"tkl":str, @"deviceOs":@"ios"} callBack:^(NSObject *object) {
                if (object != nil) {
                    WantBuyModel *model = (WantBuyModel *)object;
                    [self.buyView setModel:model];
                    UIWindow * window=[UIApplication sharedApplication].keyWindow;
                    [window addSubview:self.buyView];
                    [self.buyView setHidden:NO];
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = @"";
                }
            }];
        }
    }
    
}

-(BOOL)isHasChineseChar:(NSString *)string{
    BOOL bool_value = NO;
    for (int i=0; i<[string length]; i++){
        int a = [string characterAtIndex:i];
        if (a < 0x9fff && a > 0x4e00){
            bool_value = YES;
        }
    }
    return bool_value;
}

-(NSArray *)filterString:(NSString *)str{
    NSString *pattern = @"[^\\d\\i%%u][A-Za-z0-9]+[^\\d\\i%%u]";
     NSRegularExpression * regular = [[NSRegularExpression alloc]initWithPattern:pattern options: NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *list = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    NSMutableArray *save = [NSMutableArray array];
    for (NSTextCheckingResult * match in list){
        NSString *tem = [str substringWithRange:match.range];
        if (tem.length >= 11) {
          [save addObject:tem];
        }
        
    }
    return save;
    
    /*
     设置整体匹配范围 和 匹配属性 包含所写的正则表达式字符串。
     (regular：当做一个被发现正则表达式）
     (htmlStr：当做一个检测文本)
     (NSMakeRange(0,htmlStr.length)：返回检测范围)
     简单的说就是匹配检测文本在指定范围里有多少个 符合正则表达式字符串 属性
     */
    /*
     接下来遍历一下
     NSTextCheckingResult 是一个类用来描述项目位于通过文本检查。每个对象代表了一个请求的文本内容,被发现在分析文本块。
     */
    /*
     下面才开始进行匹配
     substringWithRange: 返回一个字符串对象,其中包含的字符的接收器在一个给定的范围内
     range: 返回结果的范围,接收方代表。
     */
}

#pragma mark - WantBuyViewDelegate
-(void)jumpTaoBao:(WantBuyModel *)model{
    
    NSURL*taobaoUrl =   [NSURL URLWithString:[NSString stringWithFormat:@"tbopen://item.taobao.com/item.htm?id=%@",model.mid]];
    if ([[UIApplication sharedApplication]canOpenURL:taobaoUrl] == YES) {
        [[UIApplication sharedApplication] openURL:taobaoUrl options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {
            if (success == NO) {
                [SVProgressHUD showErrorWithStatus:@"请安装淘宝app"];
            }
        }];
    }
    
    [self.buyView setHidden:YES];
    
}

-(void)jumpGoodsDetail:(WantBuyModel *)model{
    UINavigationController *nav = self.selectedViewController;
    
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    
    GoodsModel *goods = [[GoodsModel alloc]init];
    goods.numIid = model.mid;
    goods.sellerId = model.mid;
    
    goods.title = model.content;
    
    goods.pictUrl = model.picUrl;
    
    
    detailVC.model = goods;
    detailVC.isHomePage = YES;
    
    [nav pushViewController:detailVC animated:YES];
    
    [detailVC .tabBarController.tabBar setHidden:YES];
    
    [self.buyView setHidden:YES];
}

#pragma mark - setter / getter

-(WantBuyView *)buyView{
    if (_buyView == nil) {
        _buyView = [[WantBuyView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [_buyView setDelegate:self];
    }
   return _buyView;
}


@end
