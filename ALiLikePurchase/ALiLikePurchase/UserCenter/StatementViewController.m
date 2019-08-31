//
//  StatementViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "StatementViewController.h"
#import "NavigationView.h"
#import "StatementInfoTableViewCell.h"
#import "StatementTodayTableViewCell.h"
#import "UIColor+DD.h"

static NSString *const kStatementInfoTableViewCellIdentifier = @"StatementInfoTableViewCell";

static NSString *const kStatementTodayTableViewCellIdentifier = @"StatementTodayTableViewCell";

@interface StatementViewController ()<NavigationViewDelegate, UITableViewDelegate, UITableViewDataSource>
//导航
@property(nonatomic, strong)NavigationView *navigationView;


@property(nonatomic, strong)NSDictionary *dataDic;

@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)initUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.tableView];
    
    [self.navigationView setTitle:@"收益报表"];
    
}

-(void)initData{
    
    User *user = [[DataManager shareInstance]getUser];
    NSDictionary *dic = @{ @"appToken":user.appToken};
    
    [[DataManager shareInstance]getFeeDetail:dic callBack:^(NSDictionary *result) {
        self.dataDic = result;
        [self.tableView reloadData];
    }];
    
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
        return 0.01;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 0.01;
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    if (indexPath.row == 0) {
        return 335;
    }
    
    if (indexPath.row == 1) {
        return 150;
    }
    
    if (indexPath.row == 2) {
        return 150;
    }
    
    return tableViewH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
         StatementInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatementInfoTableViewCellIdentifier forIndexPath:indexPath];
        [cell setModel:self.dataDic];
        return cell;
        
    }
    
    if (indexPath.row == 1) {
        StatementTodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatementTodayTableViewCellIdentifier forIndexPath:indexPath];
        [cell setTitle:@"今天"];
        [cell setModel:self.dataDic];
        return cell;
    }
    
    if (indexPath.row == 2) {
        StatementTodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatementTodayTableViewCellIdentifier forIndexPath:indexPath];
        [cell setTitle:@"昨天"];
        [cell setModel:self.dataDic];
        return cell;
    }
    
    return nil;
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


-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigatorHeight, ScreenWidth, ScreenHeight - NavigatorHeight)];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StatementInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:kStatementInfoTableViewCellIdentifier];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StatementTodayTableViewCell class]) bundle:nil] forCellReuseIdentifier:kStatementTodayTableViewCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
        
    }
    
    return _tableView;
}


@end
