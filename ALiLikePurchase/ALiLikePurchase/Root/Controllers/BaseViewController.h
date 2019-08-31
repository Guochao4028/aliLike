//
//  BaseViewController.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController{
    UITableView *_tableView;
}

-(void)initUI;
-(void)initData;

@property (nonatomic, assign) BOOL vcCanScroll;

@property (nonatomic, strong)UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
