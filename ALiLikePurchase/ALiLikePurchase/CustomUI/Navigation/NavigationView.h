//
//  NavigationView.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NavigationViewDelegate <NSObject>

@optional
-(void)jumpSearchView;

-(void)jumpMessageView;

-(void)back;

-(void)inputSearchTextField:(NSString *)word;

-(void)selectMeunAction;

@end


@interface NavigationView : UIView

@property(nonatomic, copy)NSString *title;

@property(nonatomic, assign)BOOL isViewMessageJumpView;

@property(nonatomic, weak)id<NavigationViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame type:(NavigationType)type;

@property(nonatomic, assign)MeunSelectType type;

@property(nonatomic, copy)NSString *keyString;



@end

NS_ASSUME_NONNULL_END
