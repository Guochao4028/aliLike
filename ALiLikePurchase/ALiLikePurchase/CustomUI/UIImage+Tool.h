//
//  UIImage+Tool.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/18.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Tool)
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (UIImage *)snapshotWithView:(UIView *)view;

+ (NSData *)newCompressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end

NS_ASSUME_NONNULL_END
