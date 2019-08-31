//
//  LoginViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
// 登录页

#import "LoginViewController.h"
#import "PhoneLoginViewController.h"
#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "InstallmentWebViewController.h"




@interface LoginViewController ()
- (IBAction)closeAction:(UIButton *)sender;
- (IBAction)wechatLoginAction:(id)sender;
- (IBAction)phoneLoginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLogin:) name:NOTIFICATIONLOGIN object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark - UI
-(void)initUI{
    self.wechatButton.layer.cornerRadius = 15;
    self.wechatButton.layer.masksToBounds = YES;
    self.phoneLoginButton.layer.cornerRadius = 15;
    self.phoneLoginButton.layer.masksToBounds = YES;
}

#pragma mark - Action

- (IBAction)closeAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (IBAction)wechatLoginAction:(id)sender {
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    [WXApi sendReq:req];
}

- (IBAction)phoneLoginAction:(id)sender {
    PhoneLoginViewController *phoneLoginVC = [[PhoneLoginViewController alloc]init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
    
}

-(void)finishLogin:(NSNotification *) notification{
    NSDictionary *dic = notification.userInfo;
    
    [[DataManager shareInstance]weixinAuthorization:dic callBack:^(NSDictionary *result) {
                        NSString *str = result[@"type"];
                        if ([str isEqualToString:@"message"] == YES) {
                            Message *model = result[@"model"];
        
                            if ([model.code isEqualToString:@"1"] == YES) {
                                RegisterViewController *registerVC = [[RegisterViewController alloc]init];
                                [registerVC setJumpType:JumpPageWeiXinType];
                                registerVC.openid = dic[@"unionid"];
                                registerVC.dataModel = dic;
                                [self.navigationController pushViewController:registerVC animated:YES];
                            }else{
                                [SVProgressHUD showInfoWithStatus:model.reason];
                            }
                        }else if([str isEqualToString:@"user"] == YES){
                            User *model = result[@"model"];
                            if (model.tbUserId.length == 0 || model.relationId.length == 0) {
                                InstallmentWebViewController *webVC = [[InstallmentWebViewController alloc]init];
                                [self.navigationController pushViewController:webVC animated:YES];
                            }else{
                                [self.tabBarController.tabBar setHidden:NO];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            
                        }else{
                            [SVProgressHUD showInfoWithStatus:@"服务器连接失败"];
                        }
                    }];

}

- (void)dealloc {
    //移除所有观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
