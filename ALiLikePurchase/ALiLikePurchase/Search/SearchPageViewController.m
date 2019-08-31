//
//  SearchPageViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "SearchPageViewController.h"

#import "NavigationView.h"

#import "TipSearchView.h"

#import "DDLocalStore.h"

#import "TipMeunView.h"

#import "SearchListViewController.h"

@interface SearchPageViewController ()<NavigationViewDelegate, TipSearchViewDelegate, TipMeunViewDelegate>
//导航
@property(nonatomic, strong)NavigationView *navigationView;
//SearchView
@property(nonatomic, strong)TipSearchView *tipSearchView;
//搜索历史
@property (nonatomic, strong) NSMutableArray *historyArray;
//菜单
@property(nonatomic, strong)TipMeunView *meunView;

@property(nonatomic, assign)NSInteger selectMeunType;

@end

@implementation SearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.historyArray = [NSMutableArray array];
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.historyArray = [[DDLocalStore sharedStore] getSearchHistoryArrayFromLocal];
    self.tipSearchView.historyArray = self.historyArray;
    [super viewWillAppear:animated];
}

#pragma mark - ui
-(void)initUI{
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.tipSearchView];
    [self.view addSubview:self.meunView];
    self.tipSearchView.historyArray = self.historyArray;
    [self.meunView setHidden:YES];
    self.selectMeunType = MeunSelectTAOBAOType;
}

- (void)addHistoryString:(NSString *)historyString {
    
    if ([self.historyArray containsObject:historyString]) {
        [self.historyArray removeObject:historyString];
    }
    [self.historyArray insertObject:historyString atIndex:0];
    [[DDLocalStore sharedStore] saveSearchHistoryArrayToLocal:self.historyArray];
    self.tipSearchView.historyArray = self.historyArray;
    [self.tipSearchView updateHistoryList];
    
}

#pragma mark - TipSearchViewDelegate
-(void)tapLable:(NSString *)word{
    [self addHistoryString:word];
    
    SearchListViewController *searchListVC = [[SearchListViewController alloc]init];
    [searchListVC setKeyString:word];
    searchListVC.selectMeunType = self.selectMeunType;
    [self.navigationController pushViewController:searchListVC animated:YES];
}

-(void)clearList{
    self.historyArray = [NSMutableArray new];
    self.tipSearchView.historyArray = self.historyArray;
    [[DDLocalStore sharedStore] saveSearchHistoryArrayToLocal:self.historyArray];
    [self.tipSearchView updateHistoryList];
}

#pragma mark - NavigationViewDelegate
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)inputSearchTextField:(NSString *)word{
    
    [self addHistoryString:word];
    
    //todo:搜索 调到 下一个页面
    SearchListViewController *searchListVC = [[SearchListViewController alloc]init];
    [searchListVC setKeyString:word];
    searchListVC.selectMeunType = self.selectMeunType;
    [self.navigationController pushViewController:searchListVC animated:YES];
}

-(void)selectMeunAction{
    NSLog(@"selectMeunAction");
    [self.meunView setHidden:NO];
    [self.meunView setType:self.selectMeunType];
}

#pragma mark - TipMeunViewDelegate
-(void)selectedMeunType:(MeunSelectType)type{
    [self.meunView setHidden:YES];
    self.selectMeunType = type;
    [self.navigationView setType:type];
}

#pragma mark - getter / setter

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationSearchView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(TipSearchView *)tipSearchView{
    if (_tipSearchView == nil) {
        _tipSearchView = [[TipSearchView alloc]initWithFrame:CGRectMake(0, NavigatorHeight, ScreenWidth, ScreenHeight - NavigatorHeight)];
        [_tipSearchView setDelegate:self];
        
    }
    return _tipSearchView;
}

-(TipMeunView *)meunView{
    if (_meunView == nil) {
        _meunView = [[TipMeunView alloc]initWithFrame:CGRectMake(0, NavigatorHeight, ScreenWidth, 104)];
        [_meunView setDelegate:self];
    }
    return _meunView;
}



@end
