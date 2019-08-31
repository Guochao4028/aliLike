//
//  CategoryListViewController.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CategorySecondClassModel;

@interface CategoryListViewController : BaseViewController

@property(nonatomic, strong)CategorySecondClassModel *model;

@property(nonatomic, assign)BOOL isViewImage;

@property(nonatomic, strong)NSDictionary *iconDic;

@end

NS_ASSUME_NONNULL_END
