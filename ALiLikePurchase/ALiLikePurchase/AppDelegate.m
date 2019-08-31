//
//  AppDelegate.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    [self.window makeKeyAndVisible];

    RootViewController *rootViewController = [[RootViewController alloc]init];

    self.window.rootViewController = rootViewController;
//
    //注册bugly 做crash统计
    [self registerBugly];
    
    // 注册微信
    [self registerWeiXin];
   //  注册百川SDK
//    [self registerBaiChuan];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCOPYTEXT object:nil];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ALiLikePurchase"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark - 分享设置

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
        // 新接口写法
//    if (![[AlibcTradeSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
//
//    }
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}


/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
    NSLog(@"发送一个请求后，受到了微信的回应");
    
    NSString *des = [[resp class] description];
    
    NSLog(@"描述： = %@",des);
    
    //登录授权
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp*) resp;
        int errCode = response.errCode;
        switch (errCode) {
            case 0:{
                //用户同意
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                NSString *code = response.code;
                
                
                WXManager * manager =  [[WXManager alloc] init];
                
                NSDictionary * dictionary =  [manager getWeiXinAccessTokenFromCode:code];
                
                NSDictionary * userInfo =  [manager getWeiXinUserInfo:[dictionary objectForKey:@"access_token"] withOpenId:[dictionary objectForKey:@"openid"]];
                
                NSString *nickName = [userInfo objectForKey:@"nickname"];
                NSString *headimgurl = [userInfo objectForKey:@"headimgurl"];
                NSString *openid = [dictionary objectForKey:@"openid"];
                NSString *unionid = [dictionary objectForKey:@"unionid"];
                
                if (dictionary== nil && userInfo== nil && [dictionary objectForKey:@"access_token"]== nil) {
                    
                    [SVProgressHUD showErrorWithStatus:@"您过于频繁用微信登录"];
                    
                    return;
                }
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONLOGIN object:nil userInfo:@{@"nickname":nickName, @"headimgurl":headimgurl, @"openid":openid, @"deviceOs":@"ios", @"wxPubOpenId":unionid, @"unionid":unionid}];
            }
                break;
                
            default:{
                //用户取消或者拒绝授权
            }
                break;
        }
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSString * strTitle = [NSString stringWithFormat:@"分享结果"];
        switch (resp.errCode) {
            case WXSuccess:{
                strTitle = @"分享成功";
            }
                break;
        }
        [SVProgressHUD showSuccessWithStatus:strTitle];
    }
}



-(void) registerWeiXin{
    //微信注册
    [WXApi registerApp:WINXINAPPID];
}

-(void)registerBugly{
     [Bugly startWithAppId:@"c30f9d9121"];
}



-(void)registerBaiChuan{
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
//    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
//        
//    } failure:^(NSError *error) {
//        NSLog(@"Init failed: %@", error.description);
//    }];
    
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
//    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
    
//    // 配置全局的淘客参数
//    //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
//    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
//    taokeParams.pid = @"mm_363660053_433200100_109060150472"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid
//    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
//    [[AlibcTradeSDK sharedInstance] setISVCode:BAICHUANAPPID];
//
    // 设置全局配置，是否强制使用h5
//    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
}



@end
