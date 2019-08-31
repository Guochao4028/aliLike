//
//  BannerTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"

@interface BannerTableViewCell()<SDCycleScrollViewDelegate>

@property (strong, nonatomic)  SDCycleScrollView *bannerView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic,strong)NSMutableArray *redPointArray;

@property(nonatomic, strong)NSArray *imgArray;

@end

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

-(void)initUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.pageControl.numberOfPages = self.dataSource.count;
    [self.contentView addSubview:self.bannerView];
    
    [self.bannerView setFrame:self.bounds];
    self.bannerView.delegate = self;
    self.bannerView.imageURLStringsGroup = self.imgArray;
//    self.bannerView.placeholderImage = [UIImage imageNamed:@"Rotary"];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    //[self.delegate pushToOtherViewControllerwithHomeItem:item];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}

-(void)initData{
    NSMutableArray *temList = [NSMutableArray array];
    for (BannerModel *banner in self.dataSource) {
        [temList addObject:banner.imgUrl];
    }
    self.imgArray = temList;
}


#pragma  mark - getter / setter

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initData];
    [self initUI];
}

-(SDCycleScrollView *)bannerView{
    if (_bannerView == nil) {
        _bannerView = [[SDCycleScrollView alloc]initWithFrame:self.bounds];
    }
    return _bannerView;
}

@end
