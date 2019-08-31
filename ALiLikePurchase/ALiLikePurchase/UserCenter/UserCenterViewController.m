//
//  UserCenterViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "UserCenterViewController.h"
#import "NavigationView.h"
#import "UserTableViewCell.h"
#import "MarshallingTableViewCell.h"
#import "UserEntranceTableViewCell.h"
#import "ControlPanelTableViewCell.h"
#import "DestoonFinanceCashViewController.h"
#import "SetupViewController.h"
#import "FansOrdersViewController.h"
#import "OrdersViewController.h"
#import "InviteViewController.h"
#import "GoodsListViewController.h"
#import "MemberViewController.h"
#import "TeamFansViewController.h"
#import "WalletViewController.h"
#import "LoginViewController.h"

#import "StatementViewController.h"

static NSString *const kUserTableViewCellIdentifier = @"UserTableViewCell";
static NSString *const kMarshallingTableViewCellIdentifier = @"MarshallingTableViewCell";
static NSString *const kUserEntranceTableViewCellIdentifier = @"UserEntranceTableViewCell";
static NSString *const kControlPanelTableViewCellIdentifier = @"ControlPanelTableViewCell";

@interface UserCenterViewController ()<NavigationViewDelegate, UITableViewDelegate, UITableViewDataSource, UserEntranceTableViewCellDelegate, ControlPanelTableViewCellDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NavigationView *navigationView;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[DataManager shareInstance]getUser];
    
    [self initData];
    
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.tableView];
}

-(void)initData{
    User *user = [[DataManager shareInstance]getUser];
    if (user != nil) {
        [[DataManager shareInstance]getCustomerInfo:@{@"appToken":user.appToken} callBack:^(NSObject *object) {}];
    }
}

-(void)jumpPage:(NSInteger)type{
    User * user = [[DataManager shareInstance] getUser];
    if (user == nil || user.loginState == NO) {
        [self.tabBarController.tabBar setHidden:YES];
        
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        switch (type) {
            case 0:
            {
                SetupViewController *setupVC = [[SetupViewController alloc]init];
                [self.navigationController pushViewController:setupVC animated:YES];
                [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 1:
            {
                DestoonFinanceCashViewController *cashVC = [[DestoonFinanceCashViewController alloc]init];
                [self.navigationController pushViewController:cashVC animated:YES];
                User *user =  [[DataManager shareInstance]getUser];
                cashVC.user = user;
                [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 2:
            {
                OrdersViewController *vc = [[OrdersViewController alloc]init];
                 vc.orderType = @"1";
                [self.navigationController pushViewController:vc animated:YES];
                [self.tabBarController.tabBar setHidden:YES];
                
//                FansOrdersViewController *fansOrdersVC = [[FansOrdersViewController alloc]init];
//
//                fansOrdersVC.orderType = @"1";
//
//                [self.navigationController pushViewController:fansOrdersVC animated:YES];
//                [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 3:
            {
                WalletViewController *vc = [[WalletViewController alloc]init];
                vc.user = [[DataManager shareInstance]getUser];
                [self.navigationController pushViewController:vc animated:YES];
                [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 4:
            {
                TeamFansViewController *fansVC = [[TeamFansViewController alloc]init];
                User *user = [[DataManager shareInstance]getUser];
                [fansVC setUser:user];
                [self.navigationController pushViewController:fansVC animated:YES];
                 [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 5:
            {
                OrdersViewController *vc = [[OrdersViewController alloc]init];
                vc.orderType = @"2";
                [self.navigationController pushViewController:vc animated:YES];
                [self.tabBarController.tabBar setHidden:YES];
//                FansOrdersViewController *fansOrdersVC = [[FansOrdersViewController alloc]init];
//
//                fansOrdersVC.orderType = @"2";
//
//                [self.navigationController pushViewController:fansOrdersVC animated:YES];
//                [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 6:
            {
                InviteViewController *inviteVC = [[InviteViewController alloc]init];
                [inviteVC setIsPush:YES];
                [self.navigationController pushViewController:inviteVC animated:YES];
                 [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 7:
            {
                GoodsListViewController *goodsListVC = [[GoodsListViewController alloc]init];
                goodsListVC.viewControllerTitle = @"我的收藏";
                [self.navigationController pushViewController:goodsListVC animated:YES];
                 [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 8:
            {
                GoodsListViewController *goodsListVC = [[GoodsListViewController alloc]init];
                goodsListVC.viewControllerTitle = @"我的足迹";
                [self.navigationController pushViewController:goodsListVC animated:YES];
                 [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 9:
            {
                MemberViewController *memberVC = [[MemberViewController alloc]init];
                
                [self.navigationController pushViewController:memberVC animated:YES];
                 [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            case 10:
            {
                StatementViewController *memberVC = [[StatementViewController alloc]init];
                
                [self.navigationController pushViewController:memberVC animated:YES];
                 [self.tabBarController.tabBar setHidden:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -  NavigationViewDelegate
-(void)jumpSearchView{
//    NSLog(@"jumpSearchView");
}

-(void)jumpMessageView{
//    NSLog(@"jumpMessageView");
}

#pragma mark -  UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 14;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 14;
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 44;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                tableViewH = 85;
                break;
            case 1:
                tableViewH = 152;
                break;
            case 2:
                tableViewH = 82;
                break;
            default:
                break;
        }
    }else{
        tableViewH = 234;
    }

    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                //用户信息
                UserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:kUserTableViewCellIdentifier forIndexPath:indexPath];
                userCell.model = [[DataManager shareInstance]getUser];
                cell = userCell;
            }
                break;
            case 1:{
                //编组
                MarshallingTableViewCell *marshallingCell = [tableView dequeueReusableCellWithIdentifier:kMarshallingTableViewCellIdentifier];
                
                User *user = [[DataManager shareInstance]getUser];
                
                [marshallingCell setUser:user];
                cell = marshallingCell;
              
            }
                break;
            case 2:{
                //我的三个入口
                
                UserEntranceTableViewCell *userEntranceCell = [tableView dequeueReusableCellWithIdentifier:kUserEntranceTableViewCellIdentifier];
                [userEntranceCell setDelegate:self];
                cell = userEntranceCell;
            }
                break;
            default:
                break;
        }
    }else{
        
        ControlPanelTableViewCell *controlPanelCell = [tableView dequeueReusableCellWithIdentifier:kControlPanelTableViewCellIdentifier];
        [controlPanelCell setDelegate:self];
        cell = controlPanelCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                [self jumpPage:0];
            }
                break;
            case 1:{
                [self jumpPage:1];
            }
                break;
            case 2:{
                //我的三个入口
            }
                break;
            default:
                break;
        }
    }else{
        
    }
}

#pragma mark - UserEntranceTableViewCellDelegate

-(void)tapOrde{
    [self jumpPage:2];
}

-(void)tapQianban{
    
    [self jumpPage:3];
}

-(void)tapShouyiView{
    
    [self jumpPage:10];
    
}

#pragma mark - ControlPanelTableViewCellDelegate

-(void)tapItem:(UserSelectItemType)type{
    
    switch (type) {
        case UserSelectItemTuDuiType:{
            
            [self jumpPage:4];
        }
            break;
        case UserSelectItemFensiType:{
            [self jumpPage:5];

        }
            break;
        case UserSelectItemYaoQingType:{
            [self jumpPage:6];
        }
            break;
        case UserSelectItemShouCangType:{
            [self jumpPage:7];
        }
            break;
        case UserSelectItemZuJiType:{
            [self jumpPage:8];
            
        }
            break;
        case UserSelectItemHuiYuanType:{
            [self jumpPage:9];
        }
            break;
            
        default:
            break;
    }
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - getter/setter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigatorHeight,ScreenWidth, ScreenHeight - NavigatorHeight) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:RGB(249, 250, 252)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserTableViewCell class]) bundle:nil] forCellReuseIdentifier:kUserTableViewCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MarshallingTableViewCell class]) bundle:nil] forCellReuseIdentifier:kMarshallingTableViewCellIdentifier];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserEntranceTableViewCell class]) bundle:nil] forCellReuseIdentifier:kUserEntranceTableViewCellIdentifier];
        
        [_tableView registerClass:[ControlPanelTableViewCell class] forCellReuseIdentifier:kControlPanelTableViewCellIdentifier];
        
        
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationmMessageView];
        [_navigationView setDelegate:self];
        [_navigationView setIsViewMessageJumpView:YES];
    }
    return _navigationView;
}





@end
