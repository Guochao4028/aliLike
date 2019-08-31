//
//  HomeViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "HomeViewController.h"

#import "NavigationView.h"

#import "BannerTableViewCell.h"

#import "EntranceCell.h"

#import "InstructionsTableViewCell.h"

#import "GoodsListTableViewCell.h"

#import "SearchPageViewController.h"

#import "DetailViewController.h"

#import "LoginViewController.h"

#import "GCHeader.h"

#import "CategoryListViewController.h"

#import "CategorySecondClassModel.h"



static NSString *const kBannerTableViewCellIdentifier = @"BannerTableViewCell";

static NSString *const kEntranceTableViewCellIdentifier = @"EntranceTableViewCell";

static NSString *const kInstructionsTableViewCellIdentifier = @"InstructionsTableViewCell";

static NSString *const kGoodsListTableViewCellIdentifier = @"GoodsListTableViewCell";

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate, BannerTableViewCellDelegate, EntranceCellDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NavigationView *navigationView;

@property (nonatomic,strong)NSArray  *bannerArray;

@property(nonatomic, strong)NSMutableArray *goodsArray;

@property(nonatomic, strong)NSString *currentPage;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.tableView];
}

-(void)initData{
    self.goodsArray = [NSMutableArray array];
    
    self.currentPage = @"1";
    
    [[DataManager shareInstance]getHomePageFirstPartition:^(NSDictionary *result) {
        self.bannerArray = result[@"banner"];
        [self.tableView reloadData];
    }];
    
//    NSDictionary *param = @{@"deviceOs":@"android", @"pageNo":@"1", @"pageSize":@"15", @"searchName":@"", @"appToken":@""};
//
//    [[DataManager shareInstance]getHomePageGoodsListParame:param callBack:^(NSArray *result) {
//        self.goodsArray = [NSMutableArray arrayWithArray:result];
//        [self.tableView reloadData];
//    }];
    
    
    NSDictionary *param = @{@"deviceOs":@"android", @"pageNo":@"1", @"pageSize":@"15", @"searchName":@"\"\"", @"appToken":@"",@"sort":@"total_sales_des",@"searchType":@"1"};
    
    [[DataManager shareInstance]getHomePageGoodsListParame:param callBack:^(NSArray *result) {
        self.goodsArray = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    }];
    
}

#pragma mark -  NavigationViewDelegate
-(void)jumpSearchView{
    NSLog(@"jumpSearchView");
    
    SearchPageViewController *searchpageVC = [[SearchPageViewController alloc]init];
    [self.navigationController pushViewController:searchpageVC animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
}

-(void)jumpMessageView{
    NSLog(@"jumpMessageView");
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
        return self.goodsArray.count;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                //banner
                tableViewH = 162;
            }
                break;
            case 1:
            {
                //5个按钮
                tableViewH = 104;
            }
                break;
            case 2:
            {
                //5个按钮
                tableViewH = 210;
            }
                break;
            default:
                break;
        }
        
    }else{
        tableViewH = 140;
    }
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;// = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                //banner
                BannerTableViewCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:kBannerTableViewCellIdentifier forIndexPath:indexPath];
                bannerCell.dataSource = self.bannerArray;
                bannerCell.delegate = self;
                cell = bannerCell;
            }
                break;
            case 1:{
                //5个按钮
                EntranceCell *entranceCell = [tableView dequeueReusableCellWithIdentifier:kEntranceTableViewCellIdentifier];
                entranceCell.delegate = self;
                cell = entranceCell;
            }
                break;
            case 2:{
                //4个静态图
                
                InstructionsTableViewCell *instructionsCell = [tableView dequeueReusableCellWithIdentifier:kInstructionsTableViewCellIdentifier];
                
                cell = instructionsCell;
            }
                break;
            default:
                break;
        }
    }else{
        
        GoodsListTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:kGoodsListTableViewCellIdentifier];
        
        if (self.goodsArray.count > 0) {
             [goodsCell setModel:self.goodsArray[indexPath.row]];
        }
        cell = goodsCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        if (indexPath.row == 2) {
            
            [SVProgressHUD showInfoWithStatus:@"暂未开放"];
//            [self.tabBarController.tabBar setHidden:YES];
//            CategorySecondClassModel *model = [[CategorySecondClassModel alloc]init];
//            model.name = @"淘宝";
//            CategoryListViewController *categoryListVC = [[CategoryListViewController alloc]init];
//            categoryListVC.model = model;
//            categoryListVC.isViewImage = YES;
//            categoryListVC.iconDic = @{@"type":@"3"};
//            [self.navigationController pushViewController:categoryListVC animated:YES];
        }
    }
    
    if (indexPath.section != 0) {
        
        User * user = [[DataManager shareInstance] getUser];
        if (user == nil || user.loginState == NO) {
            [self.tabBarController.tabBar setHidden:YES];
            
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }else{
            //跳转商品详情
//            self.hidesBottomBarWhenPushed=YES;
            DetailViewController *detailVC = [[DetailViewController alloc]init];
            detailVC.model = self.goodsArray[indexPath.row];
            
            [detailVC setIsHomePage:YES];
            
            [self.navigationController pushViewController:detailVC animated:YES];
//            self.hidesBottomBarWhenPushed=NO;
            [self.tabBarController.tabBar setHidden:YES];
        }
    }
}

-(void)refresh{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    self.goodsArray = [NSMutableArray array];
    
    [[DataManager shareInstance]getHomePageFirstPartition:^(NSDictionary *result) {
        self.bannerArray = result[@"banner"];
        [self.tableView reloadData];
    }];
    
     NSDictionary *param = @{@"deviceOs":@"android", @"pageNo":@"1", @"pageSize":@"15", @"searchName":@"\"\"", @"appToken":@"",@"sort":@"total_sales_des",@"searchType":@"1"};
    self.currentPage = @"1";
    
    [[DataManager shareInstance]getHomePageGoodsListParame:param callBack:^(NSArray *result) {
        self.goodsArray = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

-(void)loadData{
    
    NSInteger cp = [self.currentPage integerValue];
    cp++;
    self.currentPage = [NSString stringWithFormat:@"%ld",(long)cp];
    

    
     NSDictionary *param = @{@"deviceOs":@"android", @"pageNo":self.currentPage, @"pageSize":@"15", @"searchName":@"\"\"", @"appToken":@"",@"sort":@"total_sales_des",@"searchType":@"1"};
    
    [[DataManager shareInstance]getHomePageGoodsListParame:param callBack:^(NSArray *result) {
        [self.goodsArray addObjectsFromArray:result];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -  EntranceTableViewCellDelegate
-(void)tapAction:(EntranceType)type{
    NSString *str;
    NSString *title;
    NSString *icon;
    switch (type) {
        case EntrancePinddType:{
            str = @"EntrancePinddType";
            title = @"拼多多";
            icon = @"0";
        }
            break;
        case EntranceJingdongType:{
            str = @"EntranceJingdongType";
            title = @"京东";
            icon = @"1";
        }
            break;
        case EntranceChaoShiType:{
            str = @"EntranceChaoShiType";
            title = @"天猫超市";
            icon = @"2";
        }
            break;
        case EntranceTaoBaoType:{
            str = @"EntranceTaoBaoType";
            title = @"淘宝";
            icon = @"3";
        }
            break;
        case EntranceTianMaoType:{
            str = @"EntranceTianMaoType";
            title = @"天猫";
            icon = @"4";
        }
            break;
        default:
            break;
    }
    
    NSInteger number = [icon integerValue];
    
    if (number >= 2) {
        [self.tabBarController.tabBar setHidden:YES];
        CategorySecondClassModel *model = [[CategorySecondClassModel alloc]init];
        model.name = @"淘宝";
        CategoryListViewController *categoryListVC = [[CategoryListViewController alloc]init];
        categoryListVC.iconDic = @{@"type":icon};
        categoryListVC.isViewImage = YES;
        categoryListVC.model = model;
       
        
        [self.navigationController pushViewController:categoryListVC animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂未开放"];
    }
}


#pragma mark - getter / setter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigatorHeight,ScreenWidth, ScreenHeight - NavigatorHeight) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EntranceCell class]) bundle:nil] forCellReuseIdentifier:kEntranceTableViewCellIdentifier];
        
        [_tableView registerClass:[BannerTableViewCell class] forCellReuseIdentifier:kBannerTableViewCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InstructionsTableViewCell class]) bundle:nil] forCellReuseIdentifier:kInstructionsTableViewCellIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsListTableViewCell class]) bundle:nil] forCellReuseIdentifier:kGoodsListTableViewCellIdentifier];
        
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        GCHeader *header = [GCHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.tableView.mj_header = header;
        
        
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        self.tableView.mj_footer = footer;
        
    }
    return _tableView;
}

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationmMessageView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}


@end
