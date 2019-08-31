//
//  DBManager.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsDetailModel;

@interface DBManager : NSObject

+(DBManager *)shareInstance;

-(void)writeData:(GoodsDetailModel *)model;

-(NSArray *)readData;

@end

NS_ASSUME_NONNULL_END
