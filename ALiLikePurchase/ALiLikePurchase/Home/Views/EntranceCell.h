//
//  EntranceCell.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EntranceCellDelegate <NSObject>

-(void)tapAction:(EntranceType)type;

@end

@interface EntranceCell : UITableViewCell

@property (nonatomic,weak) id<EntranceCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
