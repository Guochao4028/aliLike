//
//  TeamTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "TeamTableViewCell.h"

#import "FansModel.h"

@interface TeamTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leveLabel;
@property (weak, nonatomic) IBOutlet UILabel *yaoqingLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;

@end

@implementation TeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(FansModel *)model{
    _model = model;
    
    [self.heardImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.nameLabel setText:model.shortName];
    [self.leveLabel setText:model.grade];;
//    self.yaoqingLabel;
    [self.fansNumberLabel setText:[NSString stringWithFormat:@"粉丝数 %@", model.directFans]];
}

@end
