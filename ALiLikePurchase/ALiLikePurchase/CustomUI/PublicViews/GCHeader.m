//
//  GCHeader.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "GCHeader.h"
#import "RefreshView.h"

@interface GCHeader()

@property (strong,nonatomic) RefreshView *headerRefreshView;
@property (weak,nonatomic) UILabel *label;

@end

@implementation GCHeader

- (void)prepare
{
    [super prepare];
    
    
    _headerRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 81)];
    _headerRefreshView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, self.mj_h * 0.5);
   
    _headerRefreshView.backgroundColor = [UIColor clearColor];
    [self addSubview:_headerRefreshView];
    // 设置高度
    self.mj_h = 81;
}


//重写父类方法
//监听scrollView的contentoffset变化
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}

//监听scrollview的contentsize
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

//监听scrollview的拖拽状态的变化
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

//监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self endAnimation];
            break;
        case MJRefreshStatePulling:
            [self startAnimation];
            break;
        case MJRefreshStateRefreshing:
            [self startAnimation];
            break;
        default:
            break;
    }
}

//监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
}

- (void)startAnimation{
    [_headerRefreshView startAnimation];
}

- (void)endAnimation{
    [_headerRefreshView stopAnimation];
}



@end
