//
//  RegisterViewController.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController

@property(nonatomic, assign)JumpPageType jumpType;

@property(nonatomic, strong)NSString *openid;

@property(nonatomic, strong)NSDictionary *dataModel;

@end

NS_ASSUME_NONNULL_END
