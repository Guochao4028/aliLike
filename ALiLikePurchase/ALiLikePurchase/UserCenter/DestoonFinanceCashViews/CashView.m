//
//  CashView.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "CashView.h"

@interface CashView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)tixianAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *zhanghaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *tixianTextField;


@end

@implementation CashView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CashView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

- (IBAction)tixianAction:(id)sender {
    
    
    
    NSString *zhanghao = self.zhanghaoTextField.text;
    NSString *name = self.nameTextField.text;
    NSString *tixian = self.tixianTextField.text;
    
    if (zhanghao == nil || zhanghao.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"支付宝账号不能为空"];
        return;
    }
    
    if (name == nil || name.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"名字不能为空"];
        return;
    }
    
    if (tixian == nil || tixian.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"提现不能为空"];
        return;
    }
    
    if ([tixian integerValue] < 0.1) {
        [SVProgressHUD showErrorWithStatus:@"提现大于0"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:tixian forKey:@"applyAmount"];
    [dic setObject:name forKey:@"trueName"];
    [dic setObject:zhanghao forKey:@"aliAccount"];
    
    if([self.delegate respondsToSelector:@selector(tijiao:)]){
        [self.delegate tijiao:dic];
    }
    
}

-(void)setUser:(User *)user{
    NSString *aliAccount = user.aliAccount;
    
    if (aliAccount.length > 0 && aliAccount != nil) {
        [self.zhanghaoTextField setText:aliAccount];
    }
    [self.tixianTextField setPlaceholder:[NSString stringWithFormat:@"可提现¥%@",user.rebateAmount]];
}

@end
