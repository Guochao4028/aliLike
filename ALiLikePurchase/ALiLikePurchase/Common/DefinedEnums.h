//
//  DefinedEnums.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#ifndef DefinedEnums_h
#define DefinedEnums_h

typedef NS_ENUM(NSUInteger, NavigationType){
    
    NavigationNormalView = 0,
    NavigationMagnifyingGlassView = 10 ,
    NavigationmMessageView = 20,
    NavigationSearchView = 30,
    NavigationSearchNoWordView = 40,
};

typedef NS_ENUM(NSUInteger, EntranceType){
    
    EntrancePinddType = 1,
    EntranceJingdongType = 2,
    EntranceChaoShiType = 3,
    EntranceTaoBaoType = 4,
    EntranceTianMaoType = 5,
};

typedef NS_ENUM(NSUInteger, MeunSelectType){
    MeunSelectPDDType = 1,
    MeunSelectJDType = 2,
    MeunSelectCHAOSHIType = 3,
    MeunSelectTAOBAOType = 4,
    MeunSelectTIANMAOType = 5,
};


typedef NS_ENUM(NSUInteger, JumpPageType){
    JumpPageFromPhoneLoginType = 1,
    JumpPageWeiXinType = 2,
};

typedef NS_ENUM(NSUInteger, UserSelectItemType){
    UserSelectItemTuDuiType = 0,
    UserSelectItemFensiType = 1,
    UserSelectItemYaoQingType = 2,
    UserSelectItemShouCangType = 3,
    UserSelectItemZuJiType = 4,
    UserSelectItemHuiYuanType = 5,
 
};


typedef NS_ENUM(NSUInteger, ListType){
    ListZongHeType = 10,
    ListXiaoLiangShangType = 20,
    ListXiaoLiangXiaType = 30,
    ListJiaGeShangType = 40,
    ListJiaGeXiaType = 50,
};




#endif /* DefinedEnums_h */
