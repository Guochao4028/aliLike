//
//  CategotyItemCollectionViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "CategotyItemCollectionViewCell.h"

#import "CategorySecondClassModel.h"
@interface CategotyItemCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CategotyItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.heardImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.heardImageView.clipsToBounds = YES;
}

-(void)setDataSource:(CategorySecondClassModel *)dataSource{
    
    _dataSource = dataSource;
    
//    [self.heardImageView sd_setImageWithURL:[NSURL URLWithString:dataSource.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (cacheType == SDImageCacheTypeNone) {
//            [UIFactory addAnimationWithLayer:self.heardImageView.layer];
//        }
//    }];
    [self.heardImageView sd_setImageWithURL:[NSURL URLWithString:dataSource.imageUrl]];
    [self.nameLabel setText:dataSource.name];
    
}
@end
