//
//  EntranceCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "EntranceCell.h"

@interface EntranceCell()
@property (weak, nonatomic) IBOutlet UIView *tianmaoView;
@property (weak, nonatomic) IBOutlet UIView *taobaoView;
@property (weak, nonatomic) IBOutlet UIView *chaoshiView;
@property (weak, nonatomic) IBOutlet UIView *jingdongView;
@property (weak, nonatomic) IBOutlet UIView *pddView;

@end

@implementation EntranceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
    self.tianmaoView.tag = EntranceTianMaoType;
    [self.tianmaoView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
    self.taobaoView.tag = EntranceTaoBaoType;
    [self.taobaoView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
    self.chaoshiView.tag = EntranceChaoShiType;
    [self.chaoshiView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
    self.jingdongView.tag = EntranceJingdongType;
    [self.jingdongView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAction:)];
    [self.pddView addGestureRecognizer:tap4];
    self.pddView.tag = EntrancePinddType;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)jumpAction:(UITapGestureRecognizer *)sender{
    UIView *view = sender.view;
    if([self.delegate respondsToSelector:@selector(tapAction:)]){
        [self.delegate tapAction:view.tag];
    }
}

@end
