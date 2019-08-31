//
//  RefreshView.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "RefreshView.h"

#import "UIView+CGFrameLayout.h"

@interface RefreshView ()
@property(nonatomic, strong)UIImageView *imageView;

@property(nonatomic, strong)UILabel *label;
@end

@implementation RefreshView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
   
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
     [self.imageView setCenter:self.center];
}

- (void)startAnimation{
    [self addSubview:self.label];
    [self addSubview:self.imageView];
    self.imageView.x = (320 - 74)/2;
    self.imageView.y = 54;
    self.imageView.width = 74;
    self.imageView.height = 34;
     [self.label setFont:[UIFont fontWithName:RegularFont size:10]];
    
}

- (void)stopAnimation{
    
    [self.imageView removeFromSuperview];
    [self.label removeFromSuperview];

}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"refresh"]];
    }
    return _imageView;
}

-(UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 320, 17)];
        [_label setText:@"松手刷新"];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setTextColor:RGB(154, 155, 157)];
    }
    return _label;
}

@end
