//
//  GoodsInfoTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "GoodsInfoTableViewCell.h"
#import "GoodsDetailModel.h"
#import "UIColor+DD.h"

@interface GoodsInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *piceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *quanLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *uhquanView;


@end


@implementation GoodsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GoodsDetailModel *)model{
    
    [self.piceLabel setText:[NSString stringWithFormat:@"￥%@", model.couponAfterPrice]];
    [self.jiangLabel setText:[NSString stringWithFormat:@" 奖¥%@ ", model.commissionRate]];
    
    self.jiangLabel.layer.borderWidth = 1;
    
    self.jiangLabel.layer.borderColor = [[UIColor redColor] CGColor];
    
    
    NSString *str = [NSString stringWithFormat:@"原价¥%@", model.zkFinalPrice];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"9A9B9D"] range:NSMakeRange(0, str.length)];
    [self.yuanLabel setAttributedText:attri];
    
    [self.xiaoLabel setText:[NSString stringWithFormat:@"月销%@", model.volume]];
    [self.title setText:model.title];
    [self.quanLabel setText:[NSString stringWithFormat:@"%@元优惠券", model.coupon]];
    [self.timeLabel setText:[NSString stringWithFormat:@"使用期限：%@ - %@",model.couponStartTime, model.couponEndTime]];
    
    [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self.uhquanView addGestureRecognizer:tap];
}

-(void)tapView{
    if([self.delegate respondsToSelector:@selector(tapGoodsInfoView)]){
        [self.delegate tapGoodsInfoView];
    }
}

@end
