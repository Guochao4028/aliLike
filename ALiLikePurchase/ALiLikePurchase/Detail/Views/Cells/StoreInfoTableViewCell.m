//
//  StoreInfoTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "StoreInfoTableViewCell.h"

#import "GoodsDetailModel.h"

#import "ShopModel.h"

@interface StoreInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *baobeiTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *baobeiNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuliuTitelLabel;

@property (weak, nonatomic) IBOutlet UILabel *wuliuNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwuTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwuNumberLabel;


@end

@implementation StoreInfoTableViewCell

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
    _model = model;
    
    [self.storeNameLabel setText:self.model.shopTitle];
    
    NSInteger userType = [model.userType integerValue];
    
    if (userType == 0) {
        [self.storeImageView setImage:[UIImage imageNamed:@"tianmao"]];
    }else{
        [self.storeImageView setImage:[UIImage imageNamed:@"taobaoa"]];
    }
    
    for(int i = 0; i < model.evaluatesList.count ; i++) {
        ShopModel *shopModel = model.evaluatesList[i];
        switch (i) {
            case 0:
            {
                [self.baobeiTitleLabel setText:shopModel.title];
                [self.baobeiNumberLabel setText:shopModel.levelText];
                
            }
                break;
            case 1:
            {
                [self.wuliuTitelLabel setText:shopModel.title];
                [self.wuliuNumberLabel setText:shopModel.levelText];
                
            }
                break;
                
            case 2:
            {
                [self.fuwuTitleLabel setText:shopModel.title];
                [self.fuwuNumberLabel setText:shopModel.levelText];
            }
                break;
                
            default:
                break;
        }
    }
    
}

@end
