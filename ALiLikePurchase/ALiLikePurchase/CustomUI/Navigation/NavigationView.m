//
//  NavigationView.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "NavigationView.h"

@interface NavigationView ()<UITextFieldDelegate>

@property(nonatomic, assign)NavigationType navigationType;
@property (weak, nonatomic) UIView *baseView;

@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (strong, nonatomic) IBOutlet UIView *magnifyingGlassView;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIImageView *selectMeunImageView;


@property (weak, nonatomic) IBOutlet UIView *redPoint;
@property (weak, nonatomic) IBOutlet UIView *messageJumpView;

- (IBAction)jumpMessageView:(id)sender;
- (IBAction)backActon:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectMeunButton;

- (IBAction)selectMeunAction:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *searchInputView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchNoWordTextField;
- (IBAction)selectNoWordAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *searchNoWordMeunImaegView;

@end

@implementation NavigationView

-(instancetype)initWithFrame:(CGRect)frame type:(NavigationType)type{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NavigationView" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];
        self.navigationType = type;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    switch (self.navigationType) {
        case NavigationMagnifyingGlassView:
            self.baseView = self.normalView;
            break;
        case NavigationSearchView:
            self.baseView = self.searchView;
            break;
        case NavigationSearchNoWordView:
            self.baseView = self.searchInputView;
            break;
        case NavigationmMessageView:{
            
            self.baseView  = self.messageView;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpSearchView)];
            
            [self.messageJumpView addGestureRecognizer:tap];
        }
            
            break;
        default:
            self.baseView  = self.normalView;
            break;
    }
    [self.baseView  setFrame:self.bounds];
    [self addSubview:self.baseView];
    [self.redPoint.layer setMasksToBounds:YES];
    self.redPoint.layer.cornerRadius = 4;
    
    [self.searchTextField setDelegate:self];
    
    [self.searchNoWordTextField setDelegate:self];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.baseView setFrame:self.bounds];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if([self.delegate respondsToSelector:@selector(inputSearchTextField:)]){
        [self.delegate inputSearchTextField:textField.text];
    }
    return YES;
}

#pragma mark - action
-(void)jumpSearchView{
    if([self.delegate respondsToSelector:@selector(jumpSearchView)]){
        [self.delegate jumpSearchView];
    }
}

- (IBAction)jumpMessageView:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(jumpMessageView)]){
        [self.delegate jumpMessageView];
    }
}

- (IBAction)backActon:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}

#pragma mark - getter / setter
-(void)setIsViewMessageJumpView:(BOOL)isViewMessageJumpView{
    _isViewMessageJumpView = isViewMessageJumpView;
    [self.messageJumpView setHidden:isViewMessageJumpView];
}


- (IBAction)selectMeunAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectMeunAction)]) {
        [self.delegate selectMeunAction];
    }
}

- (IBAction)selectNoWordAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectMeunAction)]) {
        [self.delegate selectMeunAction];
    }
}

#pragma mark - setter / getter
-(void)setType:(MeunSelectType)type{
    NSString *pic;
    switch (type) {
        case MeunSelectPDDType:{
            pic = @"pdd";
        }
            break;
        case MeunSelectJDType:{
            pic = @"jingdong";
        }
            break;
        case MeunSelectCHAOSHIType:{
            pic = @"chaoshi";
        }
            break;
        case MeunSelectTAOBAOType:{
            pic = @"taobaoa";
        }
            break;
        case MeunSelectTIANMAOType:{
            pic = @"tianmao";
        }
            break;
        default:
            break;
    }
    [self.selectMeunImageView setImage:[UIImage imageNamed:pic]];
    [self.searchNoWordMeunImaegView setImage:[UIImage imageNamed:pic]];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.titleLabel setText:title];
}

-(void)setKeyString:(NSString *)keyString{
    _keyString = keyString;
    [self.searchNoWordTextField setText:keyString];
}


@end
