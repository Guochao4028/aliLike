//
//  SearchListViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "SearchListViewController.h"
#import "ResultsListViewController.h"
#import "NavigationView.h"
#import "TipMeunView.h"
#import "DDLocalStore.h"

@interface SearchListViewController ()<NavigationViewDelegate, TipMeunViewDelegate, ResultsListViewControllerDelegate>
//导航
@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)ResultsListViewController *resultsListVC;

//菜单
@property(nonatomic, strong)TipMeunView *meunView;

@property(nonatomic, assign)BOOL xialiangFlag;

@property(nonatomic, assign)BOOL jiageFlag;

@property(nonatomic, assign)ListType type;

@property(nonatomic, strong)NSString *currPage;

@property(nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation SearchListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    
    
    self.resultsListVC = [[ResultsListViewController alloc]init];
    self.resultsListVC.isPrompth = YES;
    [self.resultsListVC setDelegate:self];
    [self addChildViewController:self.resultsListVC];
    [self.view addSubview:self.resultsListVC.view];
    [self.resultsListVC.view setFrame:CGRectMake(0, NavigatorHeight, ScreenWidth,ScreenHeight - NavigatorHeight)];
    
    [self.view addSubview:self.meunView];
    [self.meunView setHidden:YES];
//    self.selectMeunType = MeunSelectTAOBAOType;
}

-(void)initData{
    
    self.dataArray = [NSMutableArray array];
    NSDictionary* dic =@{@"deviceOs":@"android",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.keyString, @"searchType":@"1", @"sort":@"total_sales", @"isTmall":[NSNumber numberWithBool:NO]};
    
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        self.dataArray = [NSMutableArray arrayWithArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        self.resultsListVC.type = ListZongHeType;
        
        self.type = ListZongHeType;
    }];
    
    self.currPage = @"1";
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
            sort = @"total_sales";
            break;
    }
    
    NSString *searchType;
    switch (self.selectMeunType) {
        case MeunSelectPDDType:{
            searchType = @"2";
        }
            break;
        case MeunSelectJDType:{
            searchType = @"3";
        }
            break;
        default:
            searchType = @"1";
            break;
    }
    NSNumber *isTmall;
    if (self.selectMeunType == MeunSelectCHAOSHIType) {
        isTmall = [NSNumber numberWithBool:YES];
    }else{
        isTmall = [NSNumber numberWithBool:NO];
    }
    NSDictionary* dic = @{@"deviceOs":@"ios",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.keyString, @"searchType":searchType,@"sort":sort, @"isTmall": isTmall};
    self.currPage = @"1";
    
    self.dataArray = [NSMutableArray array];
    
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        self.dataArray = [NSMutableArray arrayWithArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - NavigationViewDelegate
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.tabBarController.tabBar setHidden:NO];
}

-(void)selectMeunAction{
    NSLog(@"selectMeunAction");
    [self.meunView setHidden:NO];
    [self.meunView setType:self.selectMeunType];
}

-(void)inputSearchTextField:(NSString *)word{
    self.keyString = word;
    self.dataArray = [NSMutableArray array];
    NSDictionary* dic = @{@"deviceOs":@"ios",@"appToken":@"",@"pageNo":@"1",@"pageSize":@"50",@"searchName":self.keyString, @"searchType":@"1", @"sort":@"total_sales"};
    
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        self.dataArray = [NSMutableArray arrayWithArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        self.resultsListVC.type = ListZongHeType;
        
        self.type = ListZongHeType;
    }];
    

    
    self.currPage = @"1";
    
     [self addHistoryString:word];
}

- (void)addHistoryString:(NSString *)historyString {
    
    
    NSMutableArray *historyArray =[[DDLocalStore sharedStore]getSearchHistoryArrayFromLocal];
    
    if ([historyArray containsObject:historyString]) {
        [historyArray removeObject:historyString];
    }
    [historyArray insertObject:historyString atIndex:0];
    [[DDLocalStore sharedStore] saveSearchHistoryArrayToLocal:historyArray];

    
}

#pragma mark - TipMeunViewDelegate
-(void)selectedMeunType:(MeunSelectType)type{
    [self.meunView setHidden:YES];
    self.selectMeunType = type;
    [self.navigationView setType:type];
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
            sort = @"total_sales";
            break;
    }
    
    NSString *searchType;
    switch (self.selectMeunType) {
        case MeunSelectPDDType:{
            searchType = @"2";
        }
            break;
        case MeunSelectJDType:{
            searchType = @"3";
        }
            break;
        default:
            searchType = @"1";
            break;
    }
    NSNumber *isTmall;
    if (self.selectMeunType == MeunSelectCHAOSHIType) {
        isTmall = [NSNumber numberWithBool:YES];
    }else{
        isTmall = [NSNumber numberWithBool:NO];
    }
    NSDictionary* dic = @{@"deviceOs":@"ios",@"appToken":@"",@"pageNo":self.currPage,@"pageSize":@"50",@"searchName":self.keyString, @"searchType":searchType,@"hasCoupon":[NSNumber numberWithBool:YES],@"sort":sort, @"isTmall": isTmall};
    
    
    [[DataManager shareInstance]getSearchGoodsList:dic callBack:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        
        self.resultsListVC.dataList = self.dataArray;
        
        [tableView.mj_footer endRefreshing];
    }];
    
    
}


#pragma mark - getter / setter
-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationSearchNoWordView];
        [_navigationView setDelegate:self];
        [self.navigationView setType:self.selectMeunType];
    }
    return _navigationView;
}

-(void)setKeyString:(NSString *)keyString{
    _keyString = keyString;
    [self.navigationView setKeyString:keyString];
    [self initData];
}

-(TipMeunView *)meunView{
    if (_meunView == nil) {
        _meunView = [[TipMeunView alloc]initWithFrame:CGRectMake(0, NavigatorHeight, ScreenWidth, 104)];
        [_meunView setDelegate:self];
    }
    return _meunView;
}

-(void)setSelectMeunType:(NSInteger)selectMeunType{
    _selectMeunType = selectMeunType;
    [self.navigationView setType:selectMeunType];
}


@end
