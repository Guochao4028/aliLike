//
//  TipSearchView.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TipSearchViewDelegate <NSObject>

-(void)tapLable:(NSString *)word;

-(void)clearList;

@end

@interface TipSearchView : UIView

@property(nonatomic, weak)id<TipSearchViewDelegate> delegate;

//搜索历史
@property (nonatomic, strong) NSMutableArray *historyArray;

-(void)updateHistoryList;

@end

NS_ASSUME_NONNULL_END
