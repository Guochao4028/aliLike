//
//  OrderModel.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject

@property(nonatomic, copy)NSString *sellerNick;
@property(nonatomic, copy)NSString *earningTime;
@property(nonatomic, copy)NSString *itemTitle;
@property(nonatomic, copy)NSString *payPrice;
@property(nonatomic, copy)NSString *sellerShopTitle;
@property(nonatomic, copy)NSString *itemNum;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *itemImg;
@property(nonatomic, copy)NSString *orderType;
@property(nonatomic, copy)NSString *tradeId;
@property(nonatomic, copy)NSString *numIid;
@property(nonatomic, copy)NSString *tkStatus;

@property(nonatomic, copy)NSString *yuguFree;

@end

NS_ASSUME_NONNULL_END
/*
 
 sellerNick = "科必兴数码专营店",
 earningTime = "",
 itemTitle = "iPhone6数据线苹果6s充电线器7plus手机5s加长8x弯头快充6p冲电iPhonex 2米sp平板se闪充8",
 payPrice = "2.80",
 sellerShopTitle = "科必兴数码专营店",
 yuguFree = "0.82",
 itemNum = "1",
 price = "8.80",
 createTime = "2019-08-22 13:23:03",
 itemImg = "//img.alicdn.com/bao/uploaded/i3/1918069498/O1CN01nJG4lC2K28N3AqALW_!!1918069498.jpg",
 orderType = "天猫",
 tradeId = "589361251004354254",
 numIid = "578681756345",
 tkStatus = "12",
 
 */
