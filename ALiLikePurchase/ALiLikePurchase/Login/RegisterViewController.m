//
//  RegisterViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Regular.h"
#import "SVProgressHUD.h"
#import "Message.h"

#import "InstallmentWebViewController.h"


@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNubmerTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UILabel *codePromprLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *reCodeTextField;



@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

#pragma mark - UI

-(void)initUI{
    self.loginButton.layer.cornerRadius = 15;
    self.loginButton.layer.masksToBounds = YES;
}

//倒计时
-(void)countdown{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getCodeButton.userInteractionEnabled = YES;
                [self.codePromprLabel setText:@"获取验证码"];
                [self.codePromprLabel setTextColor:[UIColor lightGrayColor]];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getCodeButton.userInteractionEnabled = NO;
                [self.codePromprLabel setText:[NSString stringWithFormat:@"获取(%ds)",timeout]];
                [self.codePromprLabel setTextColor:[UIColor lightGrayColor]];
            });
            timeout--;
        }
        
    });
    dispatch_resume(timer);
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeAction:(id)sender {
    
    NSString *str = self.phoneNubmerTextField.text;
    
    if (str.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"手机号不可为空"];
        return;
    }else if (![str isRightPhoneNumber]){
        [SVProgressHUD showInfoWithStatus:@"手机号格式不正确"];
        return;
    }
    [[DataManager shareInstance]getSmsParame:@{@"telephone": str, @"smsType":@"customerRegister"} callBack:^(Message *message) {
        
        if (message.isSuccess == YES) {
        }
    }];
    
    [self countdown];
}

- (IBAction)loginAction:(id)sender {
    NSString *phone = self.phoneNubmerTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *recode = self.reCodeTextField.text;
    
    if (phone.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"手机号不可为空"];
        return;
    }
    if (![phone isRightPhoneNumber]){
        [SVProgressHUD showInfoWithStatus:@"手机号格式不正确"];
        return;
    }
    
    if (code.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
        return;
    }
    
    if (recode.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
        return;
    }
    
    if (self.jumpType == JumpPageWeiXinType) {
        
      
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataModel];
        [dic setValue:phone forKey:@"telephone"];
        [dic setValue:code forKey:@"smsCode"];
        [dic setValue:@"ios" forKey:@"deviceOs"];
        [dic setValue:recode forKey:@"upResqCode"];
        [dic setValue:self.openid forKey:@"code"];
        [self registerWeiXin:dic];
    }else{
        NSDictionary *dic = @{@"telephone" : phone, @"smsCode" : code, @"deviceOs":@"ios", @"upResqCode": recode};
        [self registerPhone:dic];
    }
}


-(void)registerPhone:(NSDictionary *)dic{
    [[DataManager shareInstance]loginAndRegister:dic callBack:^(NSDictionary *result) {
        NSString *str = result[@"type"];
        if ([str isEqualToString:@"message"] == YES) {
            Message *model = result[@"model"];
            [SVProgressHUD showInfoWithStatus:model.reason];
        }else{
            InstallmentWebViewController *webVC = [[InstallmentWebViewController alloc]init];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }];
}

-(void)registerWeiXin:(NSDictionary *)dic{
    
    [self registerPhone:dic];
    
    
//    [[DataManager shareInstance]weixinLogin:dic callBack:^(NSDictionary *result) {
//        NSString *str = result[@"type"];
//        if ([str isEqualToString:@"message"] == YES) {
//            Message *model = result[@"model"];
//            [SVProgressHUD showInfoWithStatus:model.reason];
//        }else{
//            [[DataManager shareInstance]taobaobendiAuthorizationParentController:self callBack:^(NSObject *object) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
//        }
//    }];
    
//    [[DataManager shareInstance]weixinLogin:dic callBack:^(NSDictionary *result) {
//
//    }];
    
    
//    [[DataManager shareInstance]loginAndRegister:dic callBack:^(NSDictionary *result) {
//        NSString *str = result[@"type"];
//        if ([str isEqualToString:@"message"] == YES) {
//            Message *model = result[@"model"];
//            [SVProgressHUD showInfoWithStatus:model.reason];
//        }else{
//            InstallmentWebViewController *webVC = [[InstallmentWebViewController alloc]init];
//            [self.navigationController pushViewController:webVC animated:YES];
//            //            [[DataManager shareInstance]taobaobendiAuthorizationParentController:self callBack:^(NSObject *object) {
//            //                [self.navigationController popToRootViewControllerAnimated:YES];
//            //            }];
//        }
//    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
