//
//  CategoryListViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "CategoryListViewController.h"
#import "ResultsListViewController.h"
#import "CategorySecondClassModel.h"
#import "NavigationView.h"

@interface CategoryListViewController ()<NavigationViewDelegate, ResultsListViewControllerDelegate>
//导航
@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)ResultsListViewController *resultsListVC;

@property(nonatomic, assign)BOOL xialiangFlag;

@property(nonatomic, assign)BOOL jiageFlag;

@property(nonatomic, assign)ListType type;

@property(nonatomic, strong)NSString *currPage;

@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation CategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    
    
    self.resultsListVC = [[ResultsListViewController alloc]init];
    self.resultsListVC.isPrompth = NO;
    [self.resultsListVC setDelegate:self];
    [self addChildViewController:self.resultsListVC];
    [self.view addSubview:self.resultsListVC.view];
    [self.resultsListVC.view setFrame:CGRectMake(0, NavigatorHeight, ScreenWidth,ScreenHeight - NavigatorHeight)];
    
    self.resultsListVC.isViewImage =  self.isViewImage;
    self.resultsListVC.iconDic = self.iconDic;
}

-(void)initData{
    self.dataArray = [NSMutableArray array];
    NSDictionary* dic;
    if (self.iconDic != nil) {
        NSString *icon = self.iconDic[@"type"];
        NSInteger number = [icon integerValue];
        if (number == 3) {
            dic = @{@"deviceOs":@"android",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.model.name, @"searchType":@"1",@"isTmall":[NSNumber numberWithBool:NO]};
        }else{
            dic = @{@"deviceOs":@"android",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.model.name, @"isTmall":[NSNumber numberWithBool:YES], @"searchType":@"1"};
        }
    }else{
        dic = @{@"deviceOs":@"android",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.model.name};
    }
    
    
    
    
    
    
    
    self.currPage = @"1";
    //    [[DataManager shareInstance] getCategoryGoodsListParame:dic callBack:^(NSArray *result) {
    //        self.dataArray = [NSMutableArray arrayWithArray:result];
    //
    //        self.resultsListVC.dataList = self.dataArray;
    //        self.resultsListVC.type = ListZongHeType;
    //
    //        self.type = ListZongHeType;
    //    }];
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        self.dataArray = [NSMutableArray arrayWithArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        self.resultsListVC.type = ListZongHeType;
        
        self.type = ListZongHeType;
    }];
    
}

-(void)update{
    NSString *sort;
    
    switch (self.type) {
        case ListXiaoLiangShangType:
            sort = @"total_sales_asc";
            break;
        case ListXiaoLiangXiaType:
            sort = @"total_sales_des";
            break;
        case ListJiaGeXiaType:
            sort = @"price_des";
            break;
        case ListJiaGeShangType:
            sort = @"price_asc";
            break;
            
        default:
            sort = @"tk_total_commi";
            break;
    }
    
    NSDictionary* dic = @{@"deviceOs":@"ios",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.model.name, @"searchType":@"1",@"hasCoupon":[NSNumber numberWithBool:YES],@"sort":sort, @"isTmall": [NSNumber numberWithBool:NO]};
    self.currPage = @"1";
    
    self.dataArray = [NSMutableArray array];
    
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        self.dataArray = [NSMutableArray arrayWithArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    //    [[DataManager shareInstance] getCategoryGoodsListParame:dic callBack:^(NSArray *result) {
    //        self.dataArray = [NSMutableArray arrayWithArray:result];
    //
    //        self.resultsListVC.dataList = self.dataArray;
    //
    //        [self.tableView.mj_header endRefreshing];
    //    }];
}

#pragma mark - ResultsListViewControllerDelegate


-(void)tapZongHe:(ListType)type{
    self.resultsListVC.type = ListZongHeType;
    self.type = ListZongHeType;
    [self update];
}

-(void)tapXiaoLiang:(ListType)type{
    
    if (self.xialiangFlag) {
        self.resultsListVC.type = ListXiaoLiangShangType;
        self.type = ListXiaoLiangShangType;
    }else{
        self.resultsListVC.type = ListXiaoLiangXiaType;
        self.type = ListXiaoLiangXiaType;
    }
    
    self.xialiangFlag = !self.xialiangFlag;
    
    [self update];
}

-(void)tapJiaGe:(ListType)type{
    if (self.jiageFlag) {
        self.resultsListVC.type = ListJiaGeShangType;
        self.type = ListJiaGeShangType;
    }else{
        self.resultsListVC.type = ListJiaGeXiaType;
        self.type = ListJiaGeXiaType;
    }
    
    
    self.jiageFlag = !self.jiageFlag;
    
    [self update];
}


-(void)refresh:(UITableView *)tableView{
    self.tableView = tableView;
    [self update];
}

-(void)loadData:(UITableView *)tableView{
    
    NSInteger cp = [self.currPage integerValue];
    cp++;
    self.currPage = [NSString stringWithFormat:@"%ld",(long)cp];
    NSString *sort;
    
    switch (self.type) {
        case ListXiaoLiangShangType:
            sort = @"total_sales_asc";
            break;
        case ListXiaoLiangXiaType:
            sort = @"total_sales_des";
            break;
        case ListJiaGeXiaType:
            sort = @"price_des";
            break;
        case ListJiaGeShangType:
            sort = @"price_asc";
            break;
            
        default:
            sort = @"tk_total_commi";
            break;
    }
    
    //    NSDictionary* dic = @{@"deviceOs":@"android",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.model.name, @"searchType":@"1",@"hasCoupon":@"true",@"sort":sort, @"isTmall": @"false"};
    
    NSDictionary* dic = @{@"deviceOs":@"android",@"appToken":@"",@"pageNo":self.currPage,@"pageSize":@"50",@"searchName":self.model.name, @"searchType":@"1",@"hasCoupon":[NSNumber numberWithBool:YES],@"sort":sort, @"isTmall": [NSNumber numberWithBool:NO]};
    
    
    //    [[DataManager shareInstance] getCategoryGoodsListParame:dic callBack:^(NSArray *result) {
    //
    //        [self.dataArray addObjectsFromArray:result];
    //
    //        self.resultsListVC.dataList = self.dataArray;
    //
    //        [tableView.mj_footer endRefreshing];
    //
    //    }];
    
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        [tableView.mj_footer endRefreshing];
    }];
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

-(void)setModel:(CategorySecondClassModel *)model{
    _model = model;
    [self.navigationView setTitle:model.name];
    [self initData];
}



@end
