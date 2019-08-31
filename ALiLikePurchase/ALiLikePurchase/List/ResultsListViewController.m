//
//  ResultsListViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "ResultsListViewController.h"
#import "ScreeningView.h"
#import "GoodsListTableViewCell.h"
#import "UIView+CGFrameLayout.h"
#import "PromptListView.h"
#import "DetailViewController.h"
#import "GCHeader.h"

static NSString *const kGoodsListTableViewCellIdentifier = @"GoodsListTableViewCell";

@interface ResultsListViewController ()<UITableViewDelegate, UITableViewDataSource, ScreeningViewDelegate>

@property(nonatomic, strong)ScreeningView *screeningView;

//@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)PromptListView *promptListView;

@property(nonatomic, assign)CGFloat tableViewH;



@end

@implementation ResultsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewH = (CGRectGetHeight(self.view.bounds)) - CGRectGetMaxY(self.promptListView.frame)-80;
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [self initUI];
    [super viewWillAppear:animated];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.screeningView];
    [self.view addSubview:self.promptListView];
    [self.view addSubview:self.tableView];
}

#pragma mark -  UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 140;
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;// = [[UITableViewCell alloc]init];
    
    GoodsListTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:kGoodsListTableViewCellIdentifier];
    
    [goodsCell setModel:self.dataList[indexPath.row]];
    
    if (self.isViewImage == YES) {
        [goodsCell setDic:self.iconDic];
    }
    
    cell = goodsCell;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转商品详情
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.model = self.dataList[indexPath.row];
    
    
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - ScreeningViewDelegate
-(void)tapZongHe:(ListType)type{
    if([self.delegate respondsToSelector:@selector(tapZongHe:)]){
        [self.delegate tapZongHe:type];
    }
}

-(void)tapXiaoLiang:(ListType)type{
    if([self.delegate respondsToSelector:@selector(tapXiaoLiang:)]){
        [self.delegate tapXiaoLiang:type];
    }
}

-(void)tapJiaGe:(ListType)type{
    if([self.delegate respondsToSelector:@selector(tapJiaGe:)]){
        [self.delegate tapJiaGe:type];
    }
}

#pragma mark - getter / setter

-(ScreeningView *)screeningView{
    if (_screeningView == nil) {
        _screeningView  = [[ScreeningView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
        [_screeningView setDelegate:self];
    }
    return _screeningView;
}

-(PromptListView *)promptListView{
    if (_promptListView == nil) {
        _promptListView = [[PromptListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.screeningView.frame),ScreenWidth, 34)];
    }
    return _promptListView;
}

-(void)refresh{
    if([self.delegate respondsToSelector:@selector(refresh:)]){
        [self.delegate refresh:self.tableView];
    }
}

-(void)loadData{
    if([self.delegate respondsToSelector:@selector(loadData:)]){
        [self.delegate loadData:self.tableView];
    }
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptListView.frame),ScreenWidth, self.tableViewH)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsListTableViewCell class]) bundle:nil] forCellReuseIdentifier:kGoodsListTableViewCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        GCHeader *header = [GCHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.tableView.mj_header = header;
        
        
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        self.tableView.mj_footer = footer;
    }
    return _tableView;
}

-(void)setIsPrompth:(BOOL)isPrompth{
    _isPrompth = isPrompth;
    if (isPrompth == YES) {
         self.tableViewH = (CGRectGetHeight(self.view.bounds)) - CGRectGetMaxY(self.promptListView.frame)-80;
        self.tableView.height = self.tableViewH;
        
    }else{
         self.tableViewH = (CGRectGetHeight(self.view.bounds)) - CGRectGetMaxY(self.screeningView.frame)-80;
        self.tableView.height = self.tableViewH;
        self.tableView.y = CGRectGetMaxY(self.screeningView.frame);
        
        [self.promptListView removeFromSuperview];
    
    }
}

-(void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [self.tableView reloadData];
}

-(void)setType:(ListType)type{
    
    [self.screeningView setType:type];
}


@end
