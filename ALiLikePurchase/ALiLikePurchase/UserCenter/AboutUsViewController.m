//
//  AboutUsViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "AboutUsViewController.h"

#import "UpgradeView.h"
#import "NavigationView.h"

@interface AboutUsViewController ()<NavigationViewDelegate>

//导航
@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)UpgradeView *upgradeView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self initData];
}

-(void)initUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.navigationView];
    
    [self.navigationView setTitle:@"关于我们"];
    
    [self.view addSubview:self.upgradeView];
    
    [self.upgradeView setIsLabel:YES];
}

-(void)initData{
    
}

#pragma mark - NavigationViewDelegate
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter / setter
-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(UpgradeView *)upgradeView{
    
    if (_upgradeView == nil) {
        _upgradeView = [[UpgradeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationView.frame))];
    }
    
    return _upgradeView;
}



@end
