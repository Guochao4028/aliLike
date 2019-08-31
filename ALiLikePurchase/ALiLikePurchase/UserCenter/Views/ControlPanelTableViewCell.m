//
//  ControlPanelTableViewCell.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "ControlPanelTableViewCell.h"

#import "ControlItemCell.h"

@interface ControlPanelTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSArray *dataList;

@end

@implementation ControlPanelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self initData];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return self;
}

#pragma mark - ui
-(void)initUI{
    [self.contentView addSubview:self.collectionView];
}

-(void)initData{
    self.dataList = @[@{@"name":@"团队粉丝", @"icon":@"tfensi"}, @{@"name":@"粉丝订单", @"icon":@"fdingdan"}, @{@"name":@"邀请成员", @"icon":@"yaoqin"}, @{@"name":@"我的收藏", @"icon":@"shoucan"}, @{@"name":@"我的足迹", @"icon":@"zuji"}, @{@"name":@"会员升级", @"icon":@"hui"}, ];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ControlItemCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataList[indexPath.row];
    [cell setModel:dic];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UserSelectItemType type = 0;
    switch (indexPath.row) {
        case 0:{
            type = UserSelectItemTuDuiType;
        }
            break;
        case 1:{
            type = UserSelectItemFensiType;
        }
            break;
        case 2:{
            type = UserSelectItemYaoQingType;
        }
            break;
        case 3:{
            type = UserSelectItemShouCangType;
        }
            break;
        case 4:{
            type = UserSelectItemZuJiType;
        }
            break;
        case 5:{
            type = UserSelectItemHuiYuanType;
        }
            break;
            
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(tapItem:)]){
        [self.delegate tapItem:type];
    }
}


- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}

#pragma mark - gettet/ setter

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = 70;
        CGFloat higth = 70;
        layout.itemSize = CGSizeMake(width, higth);
        layout.minimumLineSpacing = 13;
        
        if (ScreenWidth < IPHONE6WIDTH) {
            layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }else{
            layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        }
        
        _collectionView = [[UICollectionView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, 164) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
       
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ControlItemCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView setScrollEnabled:YES];

    }
    return _collectionView;
}

@end
