//
//  DestoonFinanceCashViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "DestoonFinanceCashViewController.h"
#import "CashView.h"
#import "NavigationView.h"
#import "UIColor+DD.h"
#import "CashSucceedViewController.h"

@interface DestoonFinanceCashViewController ()<NavigationViewDelegate, CashViewDelegate>

@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)CashView *cashView;


@end

@implementation DestoonFinanceCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FAFAFA"]];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.cashView];
    [self.navigationView setTitle:@"余额提现"];
}


#pragma mark - CashViewDelegate
-(void)tijiao:(NSDictionary *)dataDic{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:dataDic];
    
    [dic setObject:self.user.appToken forKey:@"appToken"];
    
    [[DataManager shareInstance]accountApplyToALiAccount:dic callBack:^(Message *message) {
        Message *model = message;
        
        NSString *code = [NSString stringWithFormat:@"%@", model.code];
        
        if ([code isEqualToString:@"0"] == YES) {
            
            CashSucceedViewController *cashSuceedVC = [[CashSucceedViewController alloc]init];
            [self.navigationController pushViewController:cashSuceedVC animated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:model.reason];
        }
    }];
    
    
}

#pragma mark - NavigationViewDelegate

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - getter / setter

-(CashView *)cashView{
    if (_cashView == nil) {
        _cashView = [[CashView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationView.frame))];
        [_cashView setDelegate:self];
    }
    return _cashView;
}

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(void)setUser:(User *)user{
    _user = user;
    [self.cashView setUser:user];
}

@end
