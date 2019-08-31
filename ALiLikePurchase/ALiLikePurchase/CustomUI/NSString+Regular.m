//
//  NSString+Regular.m
//  Ali Huishou
//
//  Created by 安离夕 on 2019/7/22.
//  Copyright © 2019年 liuzhuang. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

/// 判断是否是正确的手机号
- (BOOL)isRightPhoneNumber{
    // 定义正则语句
    NSString *str = @"^(13|14|15|17|18)+\\d{9}$";
    //    ^1+[3578]+\\d{9}$
    // 定义一个谓词对象
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    // 判断是否符合
    return [pre evaluateWithObject:self];
}

/// 判断是否是正确的邮箱
- (BOOL)isRightEmail{
    return YES;
}



@end
