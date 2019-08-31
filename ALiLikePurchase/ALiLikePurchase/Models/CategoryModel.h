//
//  CategoryModel.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CategorySecondClassModel;

@interface CategoryModel : NSObject

@property (nonatomic,strong) NSString * categoryId;//id 一级分类id
@property (nonatomic,strong) NSString * categoryName;//一级分类 服饰内衣

@property (nonatomic,strong) NSArray<CategorySecondClassModel*> * secondClassModels;//二级分类

@end

NS_ASSUME_NONNULL_END

/*
 {
 id = 1,
 childName = "文胸,内裤,袜子,保暖内衣,塑身衣,睡衣",
 childId = "18,14,17,13,16,15",
 categoryName = "服饰内衣",
 childImage = "http://login.alhuigou.com/image/type/neiyi/neiyi06.jpg,http://login.alhuigou.com/image/type/neiyi/neiyi02.jpg,http://login.alhuigou.com/image/type/neiyi/neiyi05.jpg,http://login.alhuigou.com/image/type/neiyi/neiyi01.jpg,http://login.alhuigou.com/image/type/neiyi/neiyi04.jpg,http://login.alhuigou.com/image/type/neiyi/neiyi03.jpg",
 }
 */
