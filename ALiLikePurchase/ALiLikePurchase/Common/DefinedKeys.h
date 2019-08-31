//
//  DefinedKeys.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#ifndef DefinedKeys_h
#define DefinedKeys_h


#define ScreenWidth [[UIScreen mainScreen]bounds].size.width

#define ScreenHeight [[UIScreen mainScreen]bounds].size.height

#define SHOWTIME 0.6
//iPhone 6 的高
#define IPHONE6HEIGHT 667
//iPhone 6 的宽
#define IPHONE6WIDTH  375
//高度比
#define HEIGHTPROPROTION (ScreenHeight / IPHONE6HEIGHT)
//宽度比
#define WIDTHTPROPROTION (ScreenWidth / IPHONE6WIDTH)
// 检查系统版本
#define iOS_SYSTEM_VERSION(VERSION) ([[UIDevice currentDevice].systemVersion doubleValue] >= VERSION)

#define NavigatorHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)

#define TabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define BOTTOM_MARGIN_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define CODE @"code"//状态码
#define DATAS @"data"//数据
#define ERROR @"error"//错误

#define UESRINFOSAVE    @"userInfoSave"

#define TOKEN    @"appToken"

#define RegularFont @"Regular"

#define MediumFont @"Medium"

#define UMENGAPPID @"5d58ddc53fc195595400002d"

#define WINXINAPPID @"wxa5164f2a04995525"

#define WINXINAPPSECRET @"9223b3c44bdc6d4607986a11ccf41085"

#define BAICHUANAPPID @"27775209"

#define BAICHUANAPPSECRET @"1c52d1b1013d052098126ffcb7678ce0"

#define NOTIFICATIONLOGIN  @"NotificationLogin"

#define NOTIFICATIONCOPYTEXT  @"NotificationCopyText"



#endif /* DefinedKeys_h */
