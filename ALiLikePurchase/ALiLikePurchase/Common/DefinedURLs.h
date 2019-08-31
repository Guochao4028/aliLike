//
//  DefinedURLs.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#ifndef DefinedURLs_h
#define DefinedURLs_h

//是否是内网版本
//注释 切换内外网
//#define IsInsideNewWork YES

#ifdef IsInsideNewWork
//测试环境 主域名
#define Host            @"http://testapi.alhuigou.com/alyg-web"

//@"http://aaadi.in.3322.org:28393/alyg-web"
//@"http://192.168.0.110:8080/alyg-web"
//@"http://testapi.alhuigou.com/alyg-web"

#else
//正式环境 主域名
#define Host  @"http://api.alhuigou.com/alyg-web"

#endif

#define ADD(x) [NSString stringWithFormat:@"%@%@",Host,(x)]
//手机号登录接口 & 手机号注册接口
#define URL_POST_CUSTOMER_CUSTOMERREGISTER @"/customer/customerRegister"

//微信接口
#define URL_POST_WEIXIN_GETWEIXINOPENID @"/weixin/getWeixinOpenid"

//验证码接口
#define URL_POST_CUSTOMER_SENDSMS @"/customer/sendSms"

//商品收藏接口
#define URL_POST_CUSTOMER_FAVORITE @"/customer/favorite"

///获取分类数据
#define URL_POST_THIRD_CATEGORYINFO @"/thirdParty/categoryInfo"

//首页查询
#define URL_POST_IMSCATEGOORY_HOMEPAGE @"/imsCategory/homePage"

//首页列表
#define URL_POST_THIRDPARTY_TBKITENCOUPONGET @"/thirdParty/tbkitemCouponget"

//商品详情
#define URL_POST_DINGDANXIE_DDXIAIDPRIVILEGE @"/dingdanxia/ddxiaIdPrivilege"

//分类商品列表
#define URL_POST_THIRDPARTY_TBKITEMCOUPONGET @"/thirdParty/tbkitemCouponget"

//查询接口
#define  URL_POST_THIRDPARTY_TBKMATERIALGET @"/thirdParty/tbkmaterialGet"

//淘宝授权接口
#define URL_POST_WEIXIN_TBWAPOAUTH   @"/weixin/tbkWapOauth"

//微信登录
#define URL_POST_WEIXIN_GETWEIXINOPENID  @"/weixin/getWeixinOpenid"

//微信授权登录
#define URL_POST_WEIXIN_GETWEIXINCUSTOMERINFO  @"/weixin/getWeixinCustomerInfo"

//收藏列表
#define URL_POST_CUSTOMER_FAVORITELIST @"/customer/favoriteList"

//收藏
#define URL_POST_CUSTOMER_FAVORITE @"/customer/favorite"

//判断商品是否收藏
#define URL_POST_CUSTOMER_FAVORITECHECK  @"/customer/favoriteCheck"

//我的订单
#define URL_POST_CUSTOMER_ORDERS  @"/customer/orders"

//查询粉丝
#define URL_POST_CUSTOMER_MYFANS  @"/customer/myfans"

//修改手机号
#define URL_POST_CUSTOMER_MODIFYCUSTOMERPHONE  @"/customer/modifyCustomerPhone"


//查询个人信息
#define URL_POST_CUSTOMER_CUSTOMERINFO  @"/customer/customerInfo"

//通过code调接口获取oepnId
#define URL_POST_WEIXIN_JSCONTROLLER @"/weixin/jsController"


//申请提现
#define URL_POST_ACCOUNT_APPLYTOALIACCOUNT  @"/account/applyToAliAccount"


//申请提现
#define URL_POST_CUSTOMER_EXTRACT_LIST  @"/customer/extract/list"

//收益报表
#define URL_POST_CUSTOMER_FEE_DETAIL  @"/customer/fee/detail"

//淘口令查询
#define URL_POST_THIRDPARTY_TKL_QUERY @"/thirdParty/tklQuery"

#define URL_POST_DINGDANXIA_SHOPWDETAIL @"/dingdanxia/shopWdetail"



#endif /* DefinedURLs_h */
