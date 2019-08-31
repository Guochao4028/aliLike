//
//  BannerTableViewCell.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@protocol BannerTableViewCellDelegate <NSObject>

@end

@interface BannerTableViewCell : UITableViewCell
@property (nonatomic,assign) id<BannerTableViewCellDelegate>delegate;
@property (nonatomic,strong)NSArray  *dataSource;
@end

NS_ASSUME_NONNULL_END
