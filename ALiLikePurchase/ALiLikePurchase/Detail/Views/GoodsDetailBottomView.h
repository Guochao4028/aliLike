//
//  GoodsDetailBottomView.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsDetailBottomViewDelegate <NSObject>

-(void)jumpHomePage;

-(void)tapCollection;
-(void)tapBuy;
-(void)tapShare;

@end

@interface GoodsDetailBottomView : UIView

@property(nonatomic, weak)id<GoodsDetailBottomViewDelegate> delegate;

@property(nonatomic, assign)BOOL isfavorite;

@end

NS_ASSUME_NONNULL_END
