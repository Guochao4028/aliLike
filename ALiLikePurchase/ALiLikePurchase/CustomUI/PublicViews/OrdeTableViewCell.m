//
//  OrdeTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "OrdeTableViewCell.h"
#import "OrderModel.h"

@interface  OrdeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *xidanshijianLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *piceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordeNumberLabel;

@end

@implementation OrdeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(OrderModel *)model{
    [self.xidanshijianLabel setText:[NSString stringWithFormat:@"下单时间:%@", model.createTime]];
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",model.itemImg]]];
    
    [self.ordeNumberLabel setText:[NSString stringWithFormat:@"订单号:%@", model.tradeId]];
    
    [self.piceLabel setText:[NSString stringWithFormat:@"付款%@元", model.price]];
    
    NSInteger tkStatus = [model.tkStatus integerValue];
    
    NSString *statusStr;
    
    switch (tkStatus) {
        case 1:
            statusStr = @"订单结算";
            break;
        case 12:
            statusStr = @"订单付款";

            break;
        case 13:
            statusStr = @"订单失效";

            break;
        case 14:
            statusStr = @"订单成功";
            break;
            
        default:
            statusStr = @"订单结算";
            break;
    }
    
    [self.staticLabel setText:statusStr];

//    [self.goldLabel setText:[NSString stringWithFormat:@"到账佣金￥%@", model.yuguFree]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"到账佣金￥%@", model.yuguFree]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1+model.yuguFree.length)];
    
    [self.goldLabel setAttributedText:str];

    
}



@end
