//
//  GoodsListTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "GoodsListTableViewCell.h"
#import "GoodsModel.h"
#import "UIView+CGFrameLayout.h"

@interface GoodsListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *voucherLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinLabel;
@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponBGw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponLabelW;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation GoodsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GoodsModel *)model{
    [self.goodsTitleLabel setText:model.title];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.pictUrl]];

    [self.storeTitleLabel setText:model.nick];
    
    [self.pinLabel setText:[NSString stringWithFormat:@"月销%@", model.volume]];
    
    if (model.commissionRate.length > 0) {
        [self.prizeLabel setHidden:NO];
        [self.prizeLabel setText:[NSString stringWithFormat:@"奖¥%@", model.commissionRate]];
    }else{
        [self.prizeLabel setHidden:YES];
    }
    
    NSString *couponInfo = model.couponInfo;
    
    NSString *subString;
    if (couponInfo.length > 0) {
         [self.couponView setHidden:NO];
        NSRange range = [couponInfo rangeOfString:@"减"];
        subString = [couponInfo substringFromIndex:(range.location +1)];
        
        [self.couponLabel setText:[NSString stringWithFormat:@" 劵 ¥%@ ", subString]];
        CGFloat width = [self getWidthWithText:self.couponLabel.text height:14 font:12] + 1;
        
        self.couponViewW.constant = width;
    }else{
        [self.couponView setHidden:YES];
    }
    
    NSInteger userType = [model.userType integerValue];
    
    if (userType == 0) {
        [self.storeIconImageView setImage:[UIImage imageNamed:@"tianmao"]];
    }else{
        [self.storeIconImageView setImage:[UIImage imageNamed:@"taobaoa"]];
    }
    
    if (model.couponAfterPrice.length > 0) {
        [self.voucherLabel setText:[NSString stringWithFormat:@"¥%.1f",[model.couponAfterPrice floatValue]]];
        
        [self.instructionsLabel setText:@"劵后"];
    }else{
        [self.voucherLabel setText:[NSString stringWithFormat:@"¥%.1f",[model.zkFinalPrice floatValue]]];
        
        [self.instructionsLabel setText:@"折扣价"];
    }
    
    
    
    //    self.storeIconImageView sd_setImageWithURL:[NSURL URLWithString:model.]
    
    
}

-(void)setDic:(NSDictionary *)dic{
    NSInteger userType = [dic[@"type"] integerValue];
    switch (userType) {
        case 0:{
            [self.storeIconImageView setImage:[UIImage imageNamed:@"pdd"]];
        }
            break;
        case 1:{
            [self.storeIconImageView setImage:[UIImage imageNamed:@"jingdong"]];
        }
            break;
        case 2:{
            [self.storeIconImageView setImage:[UIImage imageNamed:@"chaoshi"]];
        }
            break;
        case 3:{
            [self.storeIconImageView setImage:[UIImage imageNamed:@"taobaoa"]];
        }
            break;
        case 4:{
            [self.storeIconImageView setImage:[UIImage imageNamed:@"tianmao"]];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat )font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}


@end
