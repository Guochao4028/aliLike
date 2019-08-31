//
//  DBManager.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "DBManager.h"
#import "Goods+CoreDataClass.h"
#import "GoodsDetailModel.h"

@interface DBManager ()
///管理对象上下文
@property(strong,nonatomic)NSManagedObjectContext *managerContenxt;

///模型对象
@property(strong,nonatomic)NSManagedObjectModel *managerModel;

///存储调度器
@property(strong,nonatomic)NSPersistentStoreCoordinator *maagerDinator;

///保存数据的方法
-(void)save;
@end

@implementation DBManager
-(void)writeData:(GoodsDetailModel  *)model{
    
    Goods *goods = [NSEntityDescription insertNewObjectForEntityForName:@"Goods" inManagedObjectContext:self.managerContenxt];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    goods.goodsId = [model.numIid integerValue];
    goods.goodsData = data;
    
    if ([self cleanData:model.numIid] == YES) {
        [self save];
    }
    
    
}

-(NSArray *)readData{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Goods"];
     NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:nil];
    NSMutableArray *goodsList = [NSMutableArray array];
    for (Goods *itme in resArray) {
         GoodsDetailModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:itme.goodsData];
        if (model != nil) {
            [goodsList addObject:model];
        }
    }
    
    return goodsList;
}

///查询单个商品
-(BOOL)cleanData:(NSString *)modelid{
    BOOL flag = NO;
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Goods"];
    
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"goodsId = %@",modelid];
    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [self.managerContenxt executeFetchRequest:deleRequest error:nil];
    
    if (deleArray.count >0) {
        //从数据库中删除
        for (Goods *tem in deleArray) {
            [self.managerContenxt deleteObject:tem];
        }
        
        NSError *error = nil;
        //保存--记住保存
        if ([self.managerContenxt save:&error]) {
            flag = YES;
        }else{
            flag = NO;
        }
    }else{
        flag = YES;
    }
    
    return flag;
}


+(DBManager *)shareInstance{
    static DBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBManager alloc]init];
    });
    return instance;
}

#pragma mark - setter / getter

-(NSManagedObjectContext *)managerContenxt
{
    if (_managerContenxt == nil) {
        
        _managerContenxt = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        ///设置存储调度器
        [_managerContenxt setPersistentStoreCoordinator:self.maagerDinator];
    }
    return _managerContenxt;
}

-(NSManagedObjectModel *)managerModel
{
    
    if (_managerModel == nil) {
        
        _managerModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managerModel;
}


-(NSPersistentStoreCoordinator *)maagerDinator
{
    if (_maagerDinator == nil) {
        
        _maagerDinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managerModel];
        
        //添加存储器
        /**
         * type:一般使用数据库存储方式NSSQLiteStoreType
         * configuration:配置信息 一般无需配置
         * URL:要保存的文件路径
         * options:参数信息 一般无需设置
         */
        
        //拼接url路径
        NSURL *url = [[self getDocumentUrlPath]URLByAppendingPathComponent:@"sqlit.db" isDirectory:YES];
        
        [_maagerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    }
    return _maagerDinator;
}

-(NSURL*)getDocumentUrlPath
{
    ///获取文件位置
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
    ;
}

-(void)save
{  ///保存数据
    [self.managerContenxt save:nil];
}

@end
