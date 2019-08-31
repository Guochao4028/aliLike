//
//  ResultsListViewController.h
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ResultsListViewControllerDelegate <NSObject>

@optional
-(void)tapZongHe:(ListType)type;

-(void)tapXiaoLiang:(ListType)type;

-(void)tapJiaGe:(ListType)type;

-(void)refresh:(UITableView *)tableView;

-(void)loadData:(UITableView *)tableView;

@end

@interface ResultsListViewController : BaseViewController

@property(nonatomic, assign)BOOL isPrompth;

@property(nonatomic, assign)ListType type;

@property(nonatomic, strong)NSArray *dataList;

@property(nonatomic, weak)id<ResultsListViewControllerDelegate> delegate;





@property(nonatomic, assign)BOOL isViewImage;

@property(nonatomic, strong)NSDictionary *iconDic;


@end

NS_ASSUME_NONNULL_END
