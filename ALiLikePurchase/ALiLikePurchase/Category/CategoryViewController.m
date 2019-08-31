//
//  CategoryViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "CategoryViewController.h"

#import "CategoryModel.h"

#import "CategotyItemCollectionViewCell.h"

#import "NavigationView.h"

#import "LJCollectionViewFlowLayout.h"

#import "LeftTableViewCell.h"

#import "CollectionViewHeaderView.h"

#import "CategotyItemCollectionViewCell.h"

#import "SearchPageViewController.h"

#import "CategoryListViewController.h"


#define kCellIdentifier_CollectionView @"CollectionViewCell"
static float kLeftTableViewWidth = 90.f;
static float kCollectionViewMargin = 10.f;

@interface CategoryViewController ()<NavigationViewDelegate, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)UITableView *leftTableView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionDatas;

@property(nonatomic, strong)NSArray *tableViewDataSource;

@property (nonatomic, strong) LJCollectionViewFlowLayout *flowLayout;



@end

@implementation CategoryViewController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self initData];
    [self initUI];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.collectionView];
    [self.view setBackgroundColor:[UIColor colorWithRed:(254/255.0) green:(254/255.0) blue:(254/255.0) alpha:1]];
    [_collectionView setBackgroundColor:RGB(254, 254, 254)];
}

-(void)initData{
    _selectIndex = 0;
    _isScrollDown = YES;
    [[DataManager shareInstance]getAppCategoricalDataInfo:^(NSArray *result) {
        self.tableViewDataSource = result;
        self.collectionDatas = result;
        [self reloadData];
    }];
}

-(void)reloadData{
    [self.leftTableView reloadData];
    [self.collectionView reloadData];
    if (self.tableViewDataSource.count > 0) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}



#pragma mark -  UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableViewCell"];
    CategoryModel * model = self.tableViewDataSource[indexPath.row];
    
    [cell.name setText:model.categoryName];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex = indexPath.row;
    [self scrollToTopOfSection:_selectIndex animated:YES];
    [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionDatas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CategoryModel *model = self.collectionDatas[section];
    return model.secondClassModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategotyItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    CategoryModel *tempModel = self.collectionDatas[indexPath.section];
    
    CategorySecondClassModel *model = tempModel.secondClassModels[indexPath.row];
    cell.dataSource = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryModel *tempModel = self.collectionDatas[indexPath.section];
    CategorySecondClassModel *model = tempModel.secondClassModels[indexPath.row];
    [self.tabBarController.tabBar setHidden:YES];
//    self.hidesBottomBarWhenPushed=YES;
    CategoryListViewController *categoryListVC = [[CategoryListViewController alloc]init];
    categoryListVC.model = model;
    [self.navigationController pushViewController:categoryListVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(88, 100);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
        
        CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            CategoryModel *model = self.tableViewDataSource[indexPath.section];
            view.title.text = model.categoryName;
        }
        
        return view;
        
    }else{
        reuseIdentifier = @"CollectionViewFooterView";
        
        CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if ([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            view.title.text = @"";
        }
        
        return view;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth - kLeftTableViewWidth -kCollectionViewMargin, 35);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth - kLeftTableViewWidth -kCollectionViewMargin, 20);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark -  NavigationViewDelegate
-(void)jumpSearchView{
    //NSLog(@"jumpSearchView");
    self.hidesBottomBarWhenPushed=YES;
    SearchPageViewController *searchpageVC = [[SearchPageViewController alloc]init];
    [self.navigationController pushViewController:searchpageVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)jumpMessageView{
   // NSLog(@"jumpMessageView");
}




#pragma mark - getter / setter

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationmMessageView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(UITableView *)leftTableView{
    
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigatorHeight, 90, (ScreenHeight - NavigatorHeight))];
        [_leftTableView setDelegate:self];
        [_leftTableView setDataSource:self];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:@"LeftTableViewCell"];
        _leftTableView.showsHorizontalScrollIndicator  = NO;
        _leftTableView.showsVerticalScrollIndicator = NO;
//        [UIFactory setExtraCellLineHidden:_leftTableView];
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_leftTableView setBackgroundColor:RGB(247, 247, 247)];
    }
    
    return _leftTableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCollectionViewMargin + kLeftTableViewWidth, NavigatorHeight, ScreenWidth - kLeftTableViewWidth -kCollectionViewMargin, ScreenHeight - NavigatorHeight) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:RGB(254, 254, 254)];
     
     
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CategotyItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
        //注册分区头标题
        [_collectionView registerClass:[CollectionViewHeaderView class]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeaderView"];
        
        
        [_collectionView registerClass:[CollectionViewHeaderView class]forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionViewFooterView"];
        
    }
    return _collectionView;
}

- (LJCollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[LJCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}


@end
