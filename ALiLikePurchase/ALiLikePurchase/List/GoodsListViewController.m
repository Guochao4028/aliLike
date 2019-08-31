//
//  GoodsListViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "GoodsListViewController.h"
#import "NavigationView.h"
#import "GoodsDetailModel.h"
#import "GoodsListTableViewCell.h"
#import "DetailViewController.h"
#import "DBManager.h"

static NSString *const kGoodsListTableViewCellIdentifier = @"GoodsListTableViewCell";


@interface GoodsListViewController ()<UITableViewDelegate, UITableViewDataSource,NavigationViewDelegate>

//导航
@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)NSArray *dataList;

@property(nonatomic, assign)BOOL isFav;

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.tableView];
}

#pragma mark - NavigationViewDelegate
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark -  UITableViewDelegate & UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    return self.dataList.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    
    tableViewH = 140;
    
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;// = [[UITableViewCell alloc]init];
    
    GoodsListTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:kGoodsListTableViewCellIdentifier];
    
    if (self.isFav == NO) {
        GoodsDetailModel *model =  self.dataList[indexPath.row];
        [goodsCell setModel:model.goodsModel];
    }else{
        [goodsCell setModel:self.dataList[indexPath.row]];
    }
    
    cell = goodsCell;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转商品详情
    if (self.isFav == NO) {
//        self.hidesBottomBarWhenPushed=YES;
        DetailViewController *detailVC = [[DetailViewController alloc]init];
        GoodsDetailModel *model =  self.dataList[indexPath.row];
        [detailVC setModel:model.goodsModel];
        [self.navigationController pushViewController:detailVC animated:YES];
//        self.hidesBottomBarWhenPushed=NO;
    }else{
        DetailViewController *detailVC = [[DetailViewController alloc]init];
        [detailVC setModel:self.dataList[indexPath.row]];
        [self.navigationController pushViewController:detailVC animated:YES];
//        self.hidesBottomBarWhenPushed=NO;
    }
}

#pragma mark - getter / setter
-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigatorHeight,ScreenWidth, ScreenHeight - NavigatorHeight) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsListTableViewCell class]) bundle:nil] forCellReuseIdentifier:kGoodsListTableViewCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

-(void)setViewControllerTitle:(NSString *)viewControllerTitle{
    _viewControllerTitle = viewControllerTitle;
    [self.navigationView setTitle:viewControllerTitle];
    
    if ([viewControllerTitle isEqualToString:@"我的足迹"]) {
        self.dataList = [[DBManager shareInstance]readData];
        [self.tableView reloadData];
    }
    
    if ([viewControllerTitle isEqualToString:@"我的收藏"]) {
//        self.dataList = [[DBManager shareInstance]readData];
        
        self.isFav = YES;
        
        User *user = [[DataManager shareInstance]getUser];
        
        NSDictionary *dic = @{@"appToken":user.appToken, @"pageNo":@"1", @"pageSize":@"100", @"deviceOs":@"h5"};
        
        [[DataManager shareInstance]getFavoriteList:dic callBack:^(NSArray *result) {
            
            self.dataList = result;
            [self.tableView reloadData];
        }];
        
        [self.tableView reloadData];
    }
    
}

@end
