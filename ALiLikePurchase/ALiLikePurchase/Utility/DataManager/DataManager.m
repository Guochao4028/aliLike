//
//  DataManager.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/14.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "DataManager.h"
#import "CategoryModel.h"
#import "CategorySecondClassModel.h"
#import "BannerModel.h"
#import "GoodsModel.h"
#import "GoodsDetailModel.h"
#import "Message.h"

#import "OrderModel.h"
#import "FansModel.h"
#import "ParticularsModel.h"

#import "WantBuyModel.h"

#import "ShopModel.h"


@interface DataManager()

@property(strong, nonatomic)AFHTTPSessionManager *manager;

@property (nonatomic, strong) User * user;

@end

@implementation DataManager

-(void)getSmsParame:(NSDictionary *)param callBack:(MessageCallBack)call{
    
    [self.manager POST:ADD(URL_POST_CUSTOMER_SENDSMS) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSInteger code =  [dic[@"code"] integerValue];
        
        Message *model = [[Message alloc]init];
        model.reason = dic[@"message"];
        model.isSuccess = code == 0? YES : NO;
        call(model);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)loginAndRegister:(NSDictionary *)param callBack:(NSDictionaryCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_CUSTOMERREGISTER) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSInteger code =  [dic[@"code"] integerValue];
        if (code != 0) {
            Message *model = [[Message alloc]init];
            model.reason = dic[@"message"];
            model.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            
            NSDictionary *dic = @{@"type":@"message", @"model":model};
            call(dic);
        }else{
            [self updateUser:dic[DATAS]];
            
            NSDictionary *dic = @{@"type":@"user", @"model":self.user};
            call(dic);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void) getAppCategoricalDataInfo:(NSArrayCallBack) call{
    
    [self.manager POST:ADD(URL_POST_THIRD_CATEGORYINFO) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = dic[DATAS];
        NSArray<CategoryModel *> *modelList = [self processCategoricalData:dataArray];
        call(modelList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getHomePageFirstPartition:(NSDictionaryCallBack)call{
    [self.manager POST:ADD(URL_POST_IMSCATEGOORY_HOMEPAGE) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = dic[DATAS];
        NSDictionary *dataDic = [self processBannerData:dataArray];
        call(dataDic);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getHomePageGoodsListParame:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    
    
    [self.manager POST:ADD(URL_POST_THIRDPARTY_TBKMATERIALGET) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *dataArray = dic[DATAS];
        NSArray *goodsList = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        call(goodsList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getGoodsDetailsParame:(NSDictionary *)param callBack:(NSObjectCallBack)call{
    
    NSString *addtoken = [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
    if (addtoken != nil && addtoken.length > 0) {
        [dic setObject:addtoken forKey:TOKEN];
    }
    
    [self.manager POST:ADD(URL_POST_DINGDANXIE_DDXIAIDPRIVILEGE) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSInteger code =  [dic[@"code"] integerValue];
        
        if (code != 0) {
            
            Message *message = [[Message alloc]init];
            message.reason = dic[@"message"];
            message.code = dic[@"code"];
            call(message);
            
        }else{
            GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dic[DATAS]];
            call(model);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getCategoryGoodsListParame:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    
    [self.manager POST:ADD(URL_POST_THIRDPARTY_TBKITEMCOUPONGET) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = dic[DATAS];
        NSArray *goodsList = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        call(goodsList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getSearchGoodsList:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    [self.manager POST:ADD(URL_POST_THIRDPARTY_TBKMATERIALGET) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = dic[DATAS];
        NSArray *goodsList = [GoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        call(goodsList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(User *)getUser{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"userInfo"];
     User *person = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    [[NSUserDefaults standardUserDefaults] setObject:person.appToken forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return person;
}

-(void)taobaoAuthorization:(NSDictionary *)param callBack:(NSDictionaryCallBack)call{
    
    [self.manager POST:ADD(URL_POST_WEIXIN_TBWAPOAUTH) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)weixinLogin:(NSDictionary *)param callBack:(NSDictionaryCallBack)call{
    
    [self.manager POST:ADD(URL_POST_WEIXIN_GETWEIXINOPENID) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger code =  [dic[@"code"] integerValue];
        if (code != 0) {
            Message *model = [[Message alloc]init];
            model.reason = dic[@"message"];
            model.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            
            NSDictionary *dic = @{@"type":@"message", @"model":model};
            call(dic);
        }else{
            [self updateUser:dic[DATAS]];
            NSDictionary *dic = @{@"type":@"user", @"model":self.user};
            call(dic);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        call(nil);
    }];
}

-(void)weixinAuthorization:(NSDictionary *)param callBack:(NSDictionaryCallBack)call{
    
    [self.manager POST:ADD(URL_POST_WEIXIN_GETWEIXINCUSTOMERINFO) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSInteger code =  [dic[@"code"] integerValue];
        if (code == 0) {
            [self updateUser:dic[DATAS]];
            NSDictionary *dic = @{@"type":@"user", @"model":self.user};
            call(dic);
        }else{
            Message *model = [[Message alloc]init];
            model.reason = dic[@"message"];
            model.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            
            NSDictionary *dic = @{@"type":@"message", @"model":model};
            call(dic);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = @{@"type":@"error"};
        call(dic);
    }];
}

-(void)customerOrders:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_ORDERS) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSArray *orderArray = [self processingOrder:dic[DATAS][@"list"]];
        
//        NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
//        [orderDic setValue:orderArray forKey:@"all"];
//        NSArray *finishArray = [self processingFinishOrder:orderArray withString:@"3"];
//        [orderDic setValue:finishArray forKey:@"finish"];
//
//
//        NSArray *fukuaiArray = [self processingFinishOrder:orderArray withString:@"12"];
//       NSArray *list =  [self processingFinishOrder:orderArray withString:@"14"];
//
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:fukuaiArray];
//        [temp addObjectsFromArray:list];
//
//        [orderDic setValue:temp forKey:@"fukuan"];
//
//        NSArray *waitArray = [self processingFinishOrder:orderArray withString:@"13"];
//        [orderDic setValue:waitArray forKey:@"wait"];
        
        
//        call(orderDic);
        call(orderArray);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)weixinTBwapoauth:(NSString *)str  callBack:(NSDictionaryCallBack)call{
    NSDictionary *param = [self processingString:str];
    
    [self.manager POST:ADD(URL_POST_WEIXIN_TBWAPOAUTH) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        call(dic);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                call(nil);
    }];
    
}

-(void)selectFans:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    
    [self.manager POST:ADD(URL_POST_CUSTOMER_MYFANS) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *dataList = [self processingFans:dic[DATAS]];
        
        call(dataList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)modifyCustomerPhone:(NSDictionary *)param callBack:(MessageCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_MODIFYCUSTOMERPHONE) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        Message *message = [[Message alloc]init];
        message.reason = dic[@"message"];
        message.code = dic[@"code"];
        call(message);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getCustomerInfo:(NSDictionary *)param callBack:(NSObjectCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_CUSTOMERINFO) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        NSInteger code =  [dic[@"code"] integerValue];
        if (code != 0) {
            Message *model = [[Message alloc]init];
            model.reason = dic[@"message"];
            model.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            
            NSDictionary *dic = @{@"type":@"message", @"model":model};
            call(dic);
        }else{
            [self updateUser:dic[DATAS]];
            
            NSDictionary *dic = @{@"type":@"user", @"model":self.user};
            call(dic);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getJsControllerCode:(NSString *)code callBack:(NSObjectCallBack)call{
    
    [self.manager POST:ADD(URL_POST_WEIXIN_JSCONTROLLER) parameters:@{@"code": code} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        call(dic[DATAS]);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)goodsFavorite:(NSDictionary *)param callBack:(MessageCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_FAVORITE) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        Message *message = [[Message alloc]init];
        message.code = dic[@"code"];
        message.reason = dic[@"message"];
        call(message);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)goodsIsFavorite:(NSDictionary *)param callBack:(MessageCallBack)call{
    
    
    [self.manager POST:ADD(URL_POST_CUSTOMER_FAVORITECHECK) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        Message *message = [[Message alloc]init];
        message.code = dic[@"code"];
        message.reason = dic[@"message"];
        NSString *favStatus = dic[DATAS][@"favStatus"];
        message.isSuccess = [favStatus boolValue];
        
        call(message);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)accountApplyToALiAccount:(NSDictionary *)param callBack:(MessageCallBack)call{
    
        [self.manager POST:ADD(URL_POST_ACCOUNT_APPLYTOALIACCOUNT) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        Message *message = [[Message alloc]init];
        message.code = dic[@"code"];
        message.reason = dic[@"message"];
        NSString *favStatus = dic[DATAS][@"favStatus"];
        message.isSuccess = [favStatus boolValue];
        
        call(message);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getFavoriteList:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    
    NSString *url = ADD(URL_POST_CUSTOMER_FAVORITELIST);
    
    [self.manager POST:ADD(URL_POST_CUSTOMER_FAVORITELIST) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
       
        NSArray *dataArray = dic[DATAS];
        
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            NSDictionary *item = dic[@"ddxPrivilege"];
            GoodsModel *model = [[GoodsModel alloc]init];
            model.itemDescription = item[@"title"];
            model.shopTitle = @"";
            model.couponClickUrl =  item[@"couponClickUrl"];
            model.couponEndTime =  item[@"couponEndTime"];
            model.sellerId =  item[@"sellerId"];
            model.smallImages =  item[@"smallImages"];
            model.userType =  item[@"userType"];
            model.volume =  item[@"volume"];
            model.nick =  item[@"nick"];
            model.couponInfo =  item[@"couponInfo"];
            model.commissionRate =  item[@"commissionRate"];
            model.title =  item[@"title"];
            model.reservePrice =  item[@"reservePrice"];
            model.couponAfterPrice =  item[@"couponAfterPrice"];
            model.rebateAmount =  item[@"rebateAmount"];
            model.numIid =  item[@"numIid"];
            model.pictUrl =  item[@"pictUrl"];
            model.zkFinalPrice =  item[@"zkFinalPrice"];

            [dataList addObject:model];
        }
        
        call(dataList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getExtractList:(NSDictionary *)param callBack:(NSArrayCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_EXTRACT_LIST) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = dic[DATAS][@"list"];
        NSArray *particularsList = [ParticularsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        call(particularsList);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(BOOL)clearUser{
    self.user.loginState = NO;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"userInfo"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    if ([fileManage fileExistsAtPath:path]) {
        //文件存在
        BOOL isSuccess = [fileManage removeItemAtPath:path error:nil];
        return isSuccess;
    }else{
        return NO;
    }
}

-(void)getFeeDetail:(NSDictionary *)param callBack:(NSDictionaryCallBack)call{
    [self.manager POST:ADD(URL_POST_CUSTOMER_FEE_DETAIL) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        call(dic[DATAS]);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)queryTKL:(NSDictionary *)param callBack:(NSObjectCallBack)call{
    
    [self.manager POST:ADD(URL_POST_THIRDPARTY_TKL_QUERY) parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        WantBuyModel *model = [WantBuyModel mj_objectWithKeyValues:dic[DATAS]];
        
        call(model);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void)getGoodsShopDetail:(NSDictionary *)param callBack:(NSObjectCallBack)call{
    
    __block GoodsDetailModel *model = param[@"model"];
    
    NSDictionary *dic = @{@"appToken":param[@"appToken"], @"mid":param[@"mid"], @"deviceOs":@"ios"};
    
    [self.manager POST:ADD(URL_POST_DINGDANXIA_SHOPWDETAIL) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        model.shopTitle = dic[DATAS][@"shopTitle"];
        
        NSString *taoShopUrl = [NSString stringWithFormat:@"%@",dic[DATAS][@"taoShopUrl"]];
        model.taoShopUrl = taoShopUrl;
        NSArray *dataList = dic[DATAS][@"evaluatesList"];
        
        NSMutableArray *temArray = [NSMutableArray array];
        
        for (NSString *tempStr in dataList) {
            [temArray addObject:[self dictionaryWithJsonString:tempStr]];
        }
        
        NSMutableArray *shopEvaliates = [NSMutableArray array];
        for (NSDictionary *dic in temArray) {
            ShopModel *shop = [[ShopModel alloc]init];
            shop.title = dic[@"title"];
            shop.score = dic[@"score"];
            shop.levelText = dic[@"levelText"];
            [shopEvaliates addObject:shop];
        }
        
        model.evaluatesList = shopEvaliates;
        call(model);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
    
}

#pragma mark - private

/**
 处理Banner数据

 @param dataArray Banner数据 数组
 */
-(NSMutableDictionary *)processBannerData:(NSArray*)dataArray{
    NSMutableDictionary *savaDic = [NSMutableDictionary dictionary];
    NSMutableArray *bannerArray = [NSMutableArray array];
    NSMutableArray *picArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        NSInteger level = [dic[@"level"] integerValue];
        BannerModel *banner = [[BannerModel alloc]init];
        banner.imgUrl = dic[@"imgUrl"];
        banner.imgID = dic[@"id"];
        banner.level = dic[@"level"];
        banner.name = dic[@"name"];
        banner.sort = dic[@"sort"];
        banner.toUrl = dic[@"toUrl"];
        if (level == 0) {
            [bannerArray addObject:banner];
        }else if (level == 2) {
            [picArray addObject:banner];
        }else if (level == 1) {
            
        }
    }
    
     [savaDic setObject:bannerArray forKey:@"banner"];
     [savaDic setObject:picArray forKey:@"pic"];
    
    return savaDic;
}

/**
 处理分类数据

 @param dataArray 分类数据 数组
 
 */
-(NSMutableArray *)processCategoricalData:(NSArray*)dataArray{
 
    NSMutableArray *savaArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        CategoryModel *categoryModel = [[CategoryModel alloc]init];
        categoryModel.categoryId = dic[@"id"];
        categoryModel.categoryName = dic[@"categoryName"];
        //读取子类数据
        NSString *childNameStr = dic[@"childName"];
        NSString *childImageStr = dic[@"childImage"];
        NSString *childIdStr = dic[@"childId"];
        //所有子类数据转数组
        NSArray *childNameList =  [childNameStr componentsSeparatedByString:@","];
        NSArray *childImageList =  [childImageStr componentsSeparatedByString:@","];
        NSArray *childIdList =  [childIdStr componentsSeparatedByString:@","];
        NSMutableArray *savaChildArray = [NSMutableArray array];
        for (int i = 0; i < childIdList.count; i++) {
            CategorySecondClassModel *secondClass = [[CategorySecondClassModel alloc]init];
            secondClass.categoryId = childIdList[i];
            secondClass.name = childNameList[i];
            secondClass.imageUrl = childImageList[i];
            [savaChildArray addObject:secondClass];
        }
        
        categoryModel.secondClassModels = savaChildArray;
        [savaArray addObject:categoryModel];
    }
    return savaArray;
}

-(void)updateUser:(NSDictionary *)info{
    self.user = [User mj_objectWithKeyValues:info];
    
    self.user.loginState = YES;
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [doc stringByAppendingPathComponent:@"userInfo"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.user.appToken forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     BOOL result = [NSKeyedArchiver archiveRootObject:self.user toFile:path];
    if (result) {
        //归档成功
    }else
    {
        //归档不成功
    }
}

-(void)taobaobendiAuthorizationParentController:(UIViewController *)parentController callBack:(NSObjectCallBack)call{
    
//    if(![[ALBBSession sharedInstance] isLogin]){
//
//        ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
//        [albbSDK setAppkey:@"26025090"];
//
//        [albbSDK auth:parentController successCallback:^(ALBBSession *session) {
//            [self saveTaobaoAuthorization:session callBack:^(NSDictionary *result) {
//                call(nil);
//            }];
//        } failureCallback:^(ALBBSession *session, NSError *error) {
//            NSLog(@"%@", session);
//        }];
//    }else{
//        ALBBSession *session=[ALBBSession sharedInstance];
//        [self saveTaobaoAuthorization:session callBack:^(NSDictionary *result) {
//            call(nil);
//        }];
//    }
}

//-(void)saveTaobaoAuthorization:(ALBBSession *)session callBack:(nonnull NSDictionaryCallBack)call{
//    ALBBUser *alUser = [session getUser];
//    User *user = [[DataManager shareInstance]getUser];
//
//    NSString *code = alUser.topAccessToken;
//    NSString *nickName = alUser.nick;
//    NSString *appToken = user.appToken;
//    NSDictionary *dic = @{@"deviceOs":@"ios", @"accessToken":code, @"appToken":appToken, @"userNick":nickName, @"state": @"11"};
//    [[DataManager shareInstance]taobaoAuthorization:dic callBack:^(NSDictionary *result) {
//        call(result);
//    }];
//}


/**
 处理url 数据 返回 字典

 @param code url
 */
-(NSDictionary *)processingString:(NSString *)code{
    NSArray *dataArray = [code componentsSeparatedByString:@"?"];
    NSArray *parameterArray = [[dataArray lastObject]componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSString *tem in parameterArray) {
        NSArray *tempArray = [tem componentsSeparatedByString:@"="];
        [dic setObject:[tempArray lastObject] forKey:[tempArray firstObject]];
    }
    
    return dic;
}


/**
 打包订单数据

 @param orderArray json 数组
 @return ordermodel 数组
 */
-(NSArray *)processingOrder:(NSArray *)orderArray{
    NSArray *orderList = [OrderModel mj_objectArrayWithKeyValuesArray:orderArray];
    return orderList;
}


/**
 分装订单数据

 @param orderArray ordermodel数组
 */
-(NSArray *)processingFinishOrder:(NSArray *)orderArray withString:(NSString *)str{
    NSMutableArray *list = [NSMutableArray array];
    for (OrderModel *model in orderArray) {
        NSString *status = [NSString stringWithFormat:@"%@", model.tkStatus];
        if ([status isEqualToString:str] == YES) {
            [list addObject:model];
        }
    }
    
    return list;
}


/**
 打包 粉丝数据

 @param dataList json 数组
 */
-(NSArray *)processingFans:(NSArray *)dataList{
    
    NSArray *list = [FansModel mj_objectArrayWithKeyValuesArray:dataList];
    return list;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - getter / setter
-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        //获取请求对象
        _manager= [AFHTTPSessionManager manager];
        // 设置请求格式
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 返回数据解析类型
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        _manager.requestSerializer.timeoutInterval = 60;
    }
    return _manager;
}

+(DataManager*) shareInstance{
    static DataManager * dataManager;
    if (!dataManager) {
        dataManager = [[super allocWithZone:NULL] init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            // 当网络状态改变时调用
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:{
                    //todo:没有网络 处理
                    //NSLog(@"没有网络");
                }
                    break;
                default:{
                }
                    break;
            }
        }];
        //开始监控
        [manager startMonitoring];
    }
    return dataManager;
};

+(id) allocWithZone:(struct _NSZone *)zone{
    
    return [DataManager shareInstance];
}




@end
