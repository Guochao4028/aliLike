//
//  OrderListViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "OrderListViewController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view addSubview:self.tableView];
}

//-(UITableView *)tableView{
//    if (_orderAllTabelView == nil) {
//        _orderAllTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
//        [_orderAllTabelView setDelegate:self];
//        [_orderAllTabelView setDataSource:self];
//
//        [_orderAllTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeTableViewCell class]) bundle:nil] forCellReuseIdentifier:kOrdeTableViewCellIdentifier];
//
//        _orderAllTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        [_orderAllTabelView setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
//
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//        self.tableView.mj_footer = footer;
//    }
//
//    return _orderAllTabelView;
//}

@end
