//
//  DetailViewController.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsModel;

@interface DetailViewController : UIViewController

@property(nonatomic, strong)GoodsModel *model;

@property(nonatomic, assign)BOOL isHomePage;

@end

NS_ASSUME_NONNULL_END
