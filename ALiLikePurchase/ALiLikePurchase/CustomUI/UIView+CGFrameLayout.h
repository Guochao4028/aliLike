//
//  UIView+CGFrameLayout.h
//  Real
//
//  Created by 郭超 on 16/9/8.
//  Copyright © 2016年 真的网络科技公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, GCEdge) {

    GCEdgeLeft  = 10,
    GCEdgeRight  = 20,
    GCEdgeTop  = 30,
    GCEdgeBottom  = 40,
};

typedef NS_ENUM(NSInteger, GCDimension) {
    GCDimensionWidth = 10,
    GCDimensionHeight = 20,
};

typedef NS_ENUM(NSInteger, GCAxis) {
    GCAxisVertical = 10 ,
    GCAxisHorizontal = 20,
};


@interface UIView (CGFrameLayout)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


+ (instancetype)frameLayoutView;
- (instancetype)initForFrameLayoutView;

#pragma mark Edges
- (CGFloat)framePinEdgeToSuperviewEdge:(GCEdge)edge withInset:(CGFloat)inset;
-(CGFloat)framePinEdgeVeiw:(UIView *)peerView edge:(GCEdge)toEdge  withOffset:(CGFloat)offset;
#pragma mark Axes
- (void)frameAlignAxis:(GCAxis)axis toSameAxisOfView:(UIView *)peerView withOffset:(CGFloat)offset;


@end
