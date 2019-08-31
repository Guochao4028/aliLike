//
//  UIView+CGFrameLayout.m
//  Real
//
//  Created by 郭超 on 16/9/8.
//  Copyright © 2016年 真的网络科技公司. All rights reserved.
//

#import "UIView+CGFrameLayout.h"

@implementation UIView (CGFrameLayout)


- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}



+ (instancetype)frameLayoutView{
    UIView *view = [[self alloc]initWithFrame:CGRectZero];
    return view;
}

- (instancetype)initForFrameLayoutView{
    self = [self initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (CGFloat)framePinEdgeToSuperviewEdge:(GCEdge)edge withInset:(CGFloat)inset{
    UIView *superview = self.superview;
    return [self framePinEdgeVeiw:superview edge:edge withOffset:inset];
}

-(CGFloat)framePinEdgeVeiw:(UIView *)peerView edge:(GCEdge)toEdge  withOffset:(CGFloat)offset{

    NSAssert(peerView, @"peerView这个参数不能为空.\n View: %@",self);
    return [UIView frameForEdege:toEdge withView:peerView] + offset;
}

- (void)frameAlignAxis:(GCAxis)axis toSameAxisOfView:(UIView *)peerView withOffset:(CGFloat)offset{
    
    CGPoint centerPoint = [UIView frameForAxis:axis withView:peerView];
    
    switch (axis) {
        case GCAxisVertical:{
            centerPoint.y = offset;
        }
            break;
        case GCAxisHorizontal:{
            centerPoint.x = offset;
        }
            break;
    }

    self.center = centerPoint;
}






+(CGPoint)frameForAxis:(GCAxis)axis withView:(UIView *)peerView{

 
    CGFloat X = -1,Y = -1;
    switch (axis) {
        case GCAxisVertical:
            X = CGRectGetWidth(peerView.frame)/2;
           
            Y = 0;
            break;
        case GCAxisHorizontal:
            Y = CGRectGetHeight(peerView.frame)/2;
            X = 0;
            break;
    }
    
    CGPoint centerPoint = CGPointMake(X, Y);
    
    return centerPoint;
}

+(CGFloat)frameForEdege:(GCEdge)edge withView:(UIView *)peerView{

    CGFloat edgeFloat = -1;
    
    switch (edge) {
        case GCEdgeLeft:
            edgeFloat = CGRectGetMinX(peerView.frame);
            break;
        case GCEdgeRight:
            edgeFloat = CGRectGetMaxX(peerView.frame);
            break;
        case GCEdgeTop:
            edgeFloat = CGRectGetMinY(peerView.frame);
            break;
        case GCEdgeBottom:
            edgeFloat = CGRectGetMaxY(peerView.frame);
            break;
            
        default:
            break;
    }
    
    return edgeFloat;
}



@end
