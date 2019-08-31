//
//  BaseViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "BaseViewController.h"
#import "NavigationView.h"



@interface BaseViewController ()<NavigationViewDelegate>
@property(nonatomic, strong)NavigationView *navigationView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [self.tabBarController.tabBar setHidden:NO];
//    [super viewWillDisappear:animated];
//}


#pragma mark - UI
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)initData{
    
}



#pragma mark - getter / setter

-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationmMessageView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}



@end
