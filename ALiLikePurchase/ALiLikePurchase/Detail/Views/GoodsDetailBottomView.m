//
//  GoodsDetailBottomView.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "GoodsDetailBottomView.h"


@interface GoodsDetailBottomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UIButton *indexButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
- (IBAction)buyAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end


@implementation GoodsDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailBottomView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self.indexButton addTarget:self action:@selector(tapIndexAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.collectionButton addTarget:self action:@selector(tapCollectionAction) forControlEvents:(UIControlEventTouchUpInside)];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action
-(void)tapIndexAction{
    if ([self.delegate respondsToSelector:@selector(jumpHomePage)]) {
        [self.delegate jumpHomePage];
    }
}

-(void)tapCollectionAction{
    if ([self.delegate respondsToSelector:@selector(tapCollection)]) {
        [self.delegate tapCollection];
    }
}



- (IBAction)buyAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tapBuy)]) {
        [self.delegate tapBuy];
    }
}

- (IBAction)shareAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tapShare)]) {
        [self.delegate tapShare];
    }
}

-(void)setIsfavorite:(BOOL)isfavorite{
    _isfavorite = isfavorite;
    if (isfavorite == YES) {
        [self.collectionImageView setImage:[UIImage imageNamed:@"collect2ion_fill"]];
    }else{
         [self.collectionImageView setImage:[UIImage imageNamed:@"collection"]];
    }
}

@end
