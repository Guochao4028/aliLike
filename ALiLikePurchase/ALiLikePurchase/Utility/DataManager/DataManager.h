//
//  DataManager.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class User;

@interface DataManager : NSObject

/**
 返回用户信息

 @return uesr class
 */
-(User *)getUser;



/**
 获取分类数据

 @param call 返回分类数组
 */
-(void) getAppCategoricalDataInfo:(NSArrayCallBack) call;

/**
 获取首页第一分区数据

 @param call 首页第一分区数据
 */
-(void)getHomePageFirstPartition:(NSDictionaryCallBack)call;

/**
 获取首页商品列表数据
 
 @param call 首页商品列表数据
 */
-(void)getHomePageGoodsListParame:(NSDictionary *)param callBack:(NSArrayCallBack)call;

/**
 获取 商品详情 数据

 @param param GoodsModel
 @param call GoodsDetailModel
 */
-(void)getGoodsDetailsParame:(NSDictionary *)param callBack:(NSObjectCallBack)call;

/**
 获取 分类商品列表 数据
 */
-(void)getCategoryGoodsListParame:(NSDictionary *)param callBack:(NSArrayCallBack)call;

/**
 获取 验证码
 */
-(void)getSmsParame:(NSDictionary *)param callBack:(MessageCallBack)call;

/**
 手机号登录接口 & 手机号注册接口
 */
-(void)loginAndRegister:(NSDictionary *)param callBack:(NSDictionaryCallBack)call;

/**
 淘宝授权接口
 */
-(void)taobaoAuthorization:(NSDictionary *)param callBack:(NSDictionaryCallBack)call;


/**
 淘宝本地授权
 */
-(void)taobaobendiAuthorizationParentController:(UIViewController *)parentController callBack:(NSObjectCallBack)call;

/**
 微信登录
 */
-(void)weixinLogin:(NSDictionary *)param callBack:(NSDictionaryCallBack)call;

/**
 微信登录
 */
-(void)weixinAuthorization:(NSDictionary *)param callBack:(NSDictionaryCallBack)call;

/**
 我的订单
 */
-(void)customerOrders:(NSDictionary *)param callBack:(NSArrayCallBack)call;


/**
 h5跳 淘宝授权
 
 @param str url
 @param call 没做处理
 */
-(void)weixinTBwapoauth:(NSString *)str  callBack:(NSDictionaryCallBack)call;

/**
 查询粉丝
 */
-(void)selectFans:(NSDictionary *)param callBack:(NSArrayCallBack)call;

/**
 修改手机号
 */
-(void)modifyCustomerPhone:(NSDictionary *)param callBack:(MessageCallBack)call;

/**
 查询个人信息
 */
-(void)getCustomerInfo:(NSDictionary *)param callBack:(NSObjectCallBack)call;
/**
 通过code调接口获取oepnId
 */
-(void)getJsControllerCode:(NSString *)code callBack:(NSObjectCallBack)call;


/**
 商品收藏
 */
-(void)goodsFavorite:(NSDictionary *)param callBack:(MessageCallBack)call;

/**
 判断商品是否收藏
 */
-(void)goodsIsFavorite:(NSDictionary *)param callBack:(MessageCallBack)call;

/**
 申请提现
 */
-(void)accountApplyToALiAccount:(NSDictionary *)param callBack:(MessageCallBack)call;


/**
 收藏列表
 */
-(void)getFavoriteList:(NSDictionary *)param callBack:(NSArrayCallBack)call;


/**
 佣金提取列表
 */
-(void)getExtractList:(NSDictionary *)param callBack:(NSArrayCallBack)call;


/**
 收益报表

 @param param apptkon
 */
-(void)getFeeDetail:(NSDictionary *)param callBack:(NSDictionaryCallBack)call;

/**
 搜索接口
 */
-(void)getSearchGoodsList:(NSDictionary *)param callBack:(NSArrayCallBack)call;


/**
 清除用户数据
 */
-(BOOL)clearUser;


/**
 淘口令查询
 */
-(void)queryTKL:(NSDictionary *)param callBack:(NSObjectCallBack)call;

/**
 获取商品详情的店铺信息
 */
-(void)getGoodsShopDetail:(NSDictionary *)param callBack:(NSObjectCallBack)call;


+(DataManager*) shareInstance;

@end

NS_ASSUME_NONNULL_END
