//
//  FansOrdersViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "FansOrdersViewController.h"

#import "OrdeTableViewCell.h"

#import "NavigationView.h"
#import "UIColor+DD.h"
#import "FDSlideBar.h"
#import "FloatHeader.h"

static NSString *const kOrdeTableViewCellIdentifier = @"OrdeTableViewCell";


#define kSliderHeight 49

@interface FansOrdersViewController ()<NavigationViewDelegate,UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NavigationView *navigationView;

@property (nonatomic,strong) FDSlideBar *sliderView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL objectCanScroll;
@property (nonatomic, assign) BOOL isSelectIndex;

@property (nonatomic, strong)UITableView *orderAllTabelView;

@property(nonatomic, strong)UITableView *orderFukuanTabelView;

@property (nonatomic, strong)UITableView *orderWaitTabelView;

@property (nonatomic, strong)UITableView *orderFinishTabelView;

@property(nonatomic, strong)NSMutableArray *allArray;
@property(nonatomic, strong)NSMutableArray *finishArray;
@property(nonatomic, strong)NSMutableArray *fukuanArray;
@property(nonatomic, strong)NSMutableArray *waitArray;

@property(nonatomic, strong)NSString *currentAllPage;
@property(nonatomic, strong)NSString *currentFinishPage;
@property(nonatomic, strong)NSString *currentFukuanPage;
@property(nonatomic, strong)NSString *currentWaitPage;

@property(nonatomic, strong)User *userModel;


@end

@implementation FansOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
    [self.view addSubview:self.navigationView];
//    [self.navigationView setTitle:@"粉丝订单"];
    [self.view addSubview:self.sliderView];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.orderAllTabelView];
    [self.scrollView addSubview:self.orderFukuanTabelView];
    [self.scrollView addSubview:self.orderWaitTabelView];
    [self.scrollView addSubview:self.orderFinishTabelView];
    
}

-(void)initData{
    self.allArray = [NSMutableArray array];
    self.finishArray = [NSMutableArray array];
    self.fukuanArray = [NSMutableArray array];
    self.waitArray = [NSMutableArray array];
    
    [self loadAllOrdes];
    [self loadPaymentOrder];
    [self loadSettlementOrder];
    [self loadFailureOrder];
    
    self.currentAllPage = @"1";
    self.currentFinishPage = @"1";
    self.currentFukuanPage = @"1";
    self.currentWaitPage = @"1";
    
}

//全部
-(void)loadAllOrdes{
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":@"1", @"pageSize":@"10", @"appToken":self.userModel.appToken};
    
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        self.allArray = [NSMutableArray arrayWithArray:result];
         [self.orderAllTabelView reloadData];
    }];
}

//已付款
-(void)loadPaymentOrder{
    
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":@"1", @"pageSize":@"10", @"appToken":self.userModel.appToken, @"tbStatus":@"12"};
    
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        self.fukuanArray = [NSMutableArray arrayWithArray:result];
        [self.orderFukuanTabelView reloadData];
        
    }];
}

//已结算
-(void)loadSettlementOrder{
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":@"1", @"pageSize":@"10", @"appToken":self.userModel.appToken, @"tbStatus":@"3"};
    
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        self.finishArray = [NSMutableArray arrayWithArray:result];
        [self.orderFinishTabelView reloadData];
        
    }];
}

//已失效
-(void)loadFailureOrder{
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":@"1", @"pageSize":@"10", @"appToken":self.userModel.appToken, @"tbStatus":@"13"};
    
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        self.waitArray = [NSMutableArray arrayWithArray:result];
        [self.orderWaitTabelView reloadData];
        
    }];
}


-(void)loadingAllOrdes{
    NSInteger cp = [self.currentAllPage integerValue];
    cp++;
    self.currentAllPage = [NSString stringWithFormat:@"%ld",(long)cp];
    
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":self.currentAllPage, @"pageSize":@"10", @"appToken":self.userModel.appToken};
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        
        [self.allArray addObjectsFromArray:result];
        
        [self.orderAllTabelView reloadData];
        
        [self.orderAllTabelView.mj_footer endRefreshing];
    }];
}

-(void)loadingPaymentOrdes{
    NSInteger cp = [self.currentFukuanPage integerValue];
    cp++;
    self.currentFukuanPage = [NSString stringWithFormat:@"%ld",(long)cp];
    
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":self.currentFukuanPage, @"pageSize":@"10", @"appToken":self.userModel.appToken,@"tbStatus":@"12"};
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        
        [self.fukuanArray addObjectsFromArray:result];
        
        [self.orderFukuanTabelView reloadData];
        
        [self.orderFukuanTabelView.mj_footer endRefreshing];
    }];
    
}

-(void)loadingSettlementOrdes{
    
    NSInteger cp = [self.currentFinishPage integerValue];
    cp++;
    self.currentFinishPage = [NSString stringWithFormat:@"%ld",(long)cp];
    
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":self.currentFinishPage, @"pageSize":@"10", @"appToken":self.userModel.appToken,@"tbStatus":@"3"};
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        
        [self.finishArray addObjectsFromArray:result];
        
        [self.orderFinishTabelView reloadData];
        
        [self.orderFinishTabelView.mj_footer endRefreshing];
    }];
    
}

-(void)loadingFailurerdes{
    NSInteger cp = [self.currentWaitPage integerValue];
    cp++;
    self.currentWaitPage = [NSString stringWithFormat:@"%ld",(long)cp];
    
    NSDictionary *dic = @{@"orderType":self.orderType, @"pageNo":self.currentWaitPage, @"pageSize":@"10", @"appToken":self.userModel.appToken,@"tbStatus":@"13"};
    [[DataManager shareInstance]customerOrders:dic callBack:^(NSArray *result) {
        
        [self.waitArray addObjectsFromArray:result];
        
        [self.orderWaitTabelView reloadData];
        
        [self.orderWaitTabelView.mj_footer endRefreshing];
    }];
}

-(void)loadData{
    
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
    if (tableView == self.orderAllTabelView) {
        return self.allArray.count;
    }
    
    if (tableView == self.orderFinishTabelView) {
        return self.finishArray.count;
    }
    
    if(tableView == self.orderFukuanTabelView){
        return self.fukuanArray.count;
    }
    
    if (tableView == self.orderWaitTabelView) {
        return self.waitArray.count;
    }
    
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    
    tableViewH = 140;
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrdeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrdeTableViewCellIdentifier];
    
    if (tableView == self.orderAllTabelView) {
        [cell setModel: [self.allArray objectAtIndex:indexPath.row]];
    }
    
    if (tableView == self.orderFinishTabelView) {
        
        [cell setModel: [self.finishArray objectAtIndex:indexPath.row]];
    }
    
    if (tableView == self.orderWaitTabelView) {
        [cell setModel: [self.waitArray objectAtIndex:indexPath.row]];
    }
    
    if (tableView == self.orderFukuanTabelView) {
        
        [cell setModel: [self.fukuanArray objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isSelectIndex = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 为了横向滑动的时候，外层的tableView不动
    if (!self.isSelectIndex) {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSUInteger page = scrollView.contentOffset.x/ScreenWidth;
        [UIView animateWithDuration:0.5 animations:^{
            [self.sliderView selectSlideBarItemAtIndex:page];
        }];
        self.tableView.scrollEnabled = YES;
    }
}



#pragma mark - NavigationViewDelegate

-(void)back{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter / setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sliderView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(self.sliderView.frame))];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 4, _scrollView.frame.size.height);
    }
    return _scrollView;
}

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

- (FDSlideBar *)sliderView{//滑块部分可任意替换
    if (!_sliderView) {
        NSArray *itemArr=@[@"全部",@"已付款", @"已结算", @"已失效"];
        _sliderView = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), ScreenWidth, kSliderHeight)];
        _sliderView.backgroundColor = [UIColor whiteColor];
        _sliderView.itemsWidth= ScreenWidth /itemArr.count;
        _sliderView.itemsTitle = itemArr;
        _sliderView.itemColor = [UIColor colorWithHexString:@"272829"];
        _sliderView.itemSelectedColor = [UIColor colorWithHexString:@"f2441c"];
        _sliderView.sliderColor = [UIColor colorWithHexString:@"f2441c"];
        [_sliderView slideBarItemSelectedCallback:^(NSUInteger idx) {
            [UIView animateWithDuration:0.5 animations:^{
            }];
            
            [self.scrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
        }];
    }
    return _sliderView;
}

-(UITableView *)orderAllTabelView{
    if (_orderAllTabelView == nil) {
        _orderAllTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        [_orderAllTabelView setDelegate:self];
        [_orderAllTabelView setDataSource:self];
        
        [_orderAllTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeTableViewCell class]) bundle:nil] forCellReuseIdentifier:kOrdeTableViewCellIdentifier];
        
        _orderAllTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_orderAllTabelView setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadingAllOrdes)];
        _orderAllTabelView.mj_footer = footer;
    }
    
    return _orderAllTabelView;
}

-(UITableView *)orderWaitTabelView{
    if (_orderWaitTabelView == nil) {
        _orderWaitTabelView = [[UITableView alloc]initWithFrame:CGRectMake(3 * ScreenWidth, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        
        [_orderWaitTabelView setDelegate:self];
        [_orderWaitTabelView setDataSource:self];
        [_orderWaitTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeTableViewCell class]) bundle:nil] forCellReuseIdentifier:kOrdeTableViewCellIdentifier];
        _orderWaitTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_orderWaitTabelView setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadingFailurerdes)];
        _orderWaitTabelView.mj_footer = footer;
    }
    
    return _orderWaitTabelView;
}

-(UITableView *)orderFukuanTabelView{
    if (_orderFukuanTabelView == nil) {
        _orderFukuanTabelView = [[UITableView alloc]initWithFrame:CGRectMake(1 * ScreenWidth, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        
        [_orderFukuanTabelView setDelegate:self];
        [_orderFukuanTabelView setDataSource:self];
        [_orderFukuanTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeTableViewCell class]) bundle:nil] forCellReuseIdentifier:kOrdeTableViewCellIdentifier];
        _orderFukuanTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_orderFukuanTabelView setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadingPaymentOrdes)];
        _orderFukuanTabelView.mj_footer = footer;
    }
    
    return _orderFukuanTabelView;
}


-(UITableView *)orderFinishTabelView{
    if (_orderFinishTabelView == nil) {
        _orderFinishTabelView = [[UITableView alloc]initWithFrame:CGRectMake(2 * ScreenWidth, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        
        [_orderFinishTabelView setDelegate:self];
        [_orderFinishTabelView setDataSource:self];
        
        
        [_orderFinishTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeTableViewCell class]) bundle:nil] forCellReuseIdentifier:kOrdeTableViewCellIdentifier];
        _orderFinishTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_orderFinishTabelView setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadingSettlementOrdes)];
        _orderFinishTabelView.mj_footer = footer;
    }
    
    return _orderFinishTabelView;
}

-(void)setOrderType:(NSString *)orderType{
    _orderType = orderType;
    
    if ([orderType isEqualToString:@"2"]) {
        [self.navigationView setTitle:@"粉丝订单"];
    }else{
        [self.navigationView setTitle:@"我的订单"];
    }
}

-(User *)userModel{
    _userModel = [[DataManager shareInstance] getUser];
    return _userModel;
}

@end
