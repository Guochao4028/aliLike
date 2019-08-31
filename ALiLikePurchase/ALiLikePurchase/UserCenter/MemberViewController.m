//
//  MemberViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "MemberViewController.h"
#import "UpgradeView.h"
#import "NavigationView.h"

@interface MemberViewController ()<NavigationViewDelegate>
//导航
@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)UpgradeView *upgradeView;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.navigationView];
    
    [self.navigationView setTitle:@"会员升级"];
    
    [self.view addSubview:self.upgradeView];
    
    [self.upgradeView setIsLabel:NO];
}

#pragma mark - NavigationViewDelegate
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
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
