//
//  NSString+Regular.h
//  Ali Huishou
//
//  Created by 安离夕 on 2019/7/22.
//  Copyright © 2019年 liuzhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regular)
/// 判断是否是正确的手机号
- (BOOL)isRightPhoneNumber;

/// 判断是否是正确的邮箱
- (BOOL)isRightEmail;
@end

NS_ASSUME_NONNULL_END
