//
//  CreateShareViewController.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/17.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "CreateShareViewController.h"
#import "GoodsDetailModel.h"
#import "NavigationView.h"
#import "UIImage+Tool.h"

#import "CreateShareHeardView.h"
#import "ShareCopyView.h"
#import "SharePicView.h"
#import "SharetoTextView.h"
#import "GenerateImageView.h"

#import "ShareModel.h"

#import <Photos/Photos.h>

#import "MLPhotoBrowserAssets.h"
#import "MLPhotoBrowserViewController.h"




@interface CreateShareViewController ()<NavigationViewDelegate, SharetoTextViewDelegate, SharePicViewDelegate,MLPhotoBrowserViewControllerDataSource,MLPhotoBrowserViewControllerDelegate>

@property(nonatomic, strong)NavigationView *navigationView;

@property(nonatomic, strong)CreateShareHeardView *createShareHeardView;
@property(nonatomic, strong)ShareCopyView *shareCopyView;
@property(nonatomic, strong)SharePicView *sharePicView;
@property(nonatomic, strong)SharetoTextView *sharetoTextView;
@property(nonatomic, strong)GenerateImageView *generateImageView;

@property(nonatomic, strong)NSArray *imageList;

@property(nonatomic, strong)UIScrollView *scrollView;

@end

@implementation CreateShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    [self.navigationView setTitle:@"创建分享"];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.createShareHeardView];
    [self.scrollView addSubview:self.shareCopyView];
    [self.scrollView addSubview:self.sharePicView];
    [self.scrollView addSubview:self.sharetoTextView];
    
}

-(void)initData{
    NSMutableArray *sava = [NSMutableArray array];
    for (NSString *urlStr in self.model.smallImages) {
        @autoreleasepool {
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            [sava addObject:imageView];
        }
    }
    
    self.imageList = sava;
}

-(NSArray *)getPic:(NSArray *)picStringArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in picStringArray) {
        @autoreleasepool {
            UIImageView *c = [[UIImageView alloc]init];
            [c sd_setImageWithURL:[NSURL URLWithString:str]];
            UIImage *temp = [UIImage compressImage:c.image toByte:32768 ];
            [array addObject:temp];
        }
    }
    return array;
}

#pragma mark - NavigationViewDelegate
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SharetoTextViewDelegate
-(void)tapSavePic{
    NSArray *picArray = [self getPic:self.sharePicView.selectImgList];
    

    for (UIImage *image in picArray) {
        @autoreleasepool {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                    {
                        // 用户拒绝，跳转到自定义提示页面
                        NSLog(@"用户拒绝");
                        [SVProgressHUD showErrorWithStatus:@"您已拒绝，请开启权限"];
                    }
                    else if (status == PHAuthorizationStatusAuthorized)
                    {
                        // 用户授权，弹出相册对话框
                        NSLog(@"用户同意");
                        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"%@",@"保存失败");
                                [SVProgressHUD showErrorWithStatus:@"保存失败"];
                            } else {
                                NSLog(@"%@",@"保存成功");
                                 [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                            }
                        }];
                    }
                });
            }];
            
        }
    }
}

-(void)tapSendWeiXin{
    
    //微信只能分享一张图片所以取到图片数组时需要判断
    //如果是一张时，正常调微信分享
    //如果是多张，先合成一张图，调用微信分享
    
    NSArray *picArray = [self getPic:self.sharePicView.selectImgList];
    UIImage *img;
    if(picArray.count == 1){
        img = [picArray lastObject];
    }else{
        [self.generateImageView setModel:self.model];
        UIImage *temp = [UIImage snapshotWithView:self.generateImageView];
        img = [UIImage compressImage:temp toByte:32768];
    }
    
    
    NSData *imageData = [UIImage newCompressImage:img toByte:32760];
//    [ShareModel shareToWeChatToSession:self.model.title withDescription:self.model.itemDescription withThumbImage:imageData withUrl:self.model.couponClickUrl];
    
    [ShareModel shareToWeChatToSession:imageData];
}

-(void)tapSendPengyouquan{
    
    NSArray *picArray = [self getPic:self.sharePicView.selectImgList];
    UIImage *img;
    if(picArray.count == 1){
        img = [picArray lastObject];
    }else{
        [self.generateImageView setModel:self.model];
        UIImage *temp = [UIImage snapshotWithView:self.generateImageView];
        img = [UIImage compressImage:temp toByte:32768];
    }
    NSData *imageData = [UIImage newCompressImage:img toByte:32760];
    
//    [ShareModel shareToWeChatToTimeline:self.model.title withDescription:self.model.itemDescription withThumbImage:imageData withUrl:self.model.couponClickUrl];
    
   [ShareModel shareToWeChatToTimeline:imageData];
    
}

-(void)tapImage:(NSIndexPath *)indexPath{
    // 图片游览器
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusFade;
    // 可以删除
    photoBrowser.editing = NO;
    // 数据源/delegate
    photoBrowser.delegate = self;
    photoBrowser.dataSource = self;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [photoBrowser show];
}

#pragma mark - <MLPhotoBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    
    return self.imageList.count;
}

#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    //原：
    //    photo.photoObj = icon.image;
    //    photo.toView = icon;
    //    photo.thumbImage = icon.image;
    //    return photo;
    
    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
    
    UIImageView *imageView =self.imageList[indexPath.row];
    
    photo.photoObj = imageView.image;
    // 缩略图
    photo.toView =  imageView;
    photo.thumbImage =  imageView.image;
    return photo;
}

#pragma mark - getter / setter
-(NavigationView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigatorHeight) type:NavigationNormalView];
        [_navigationView setDelegate:self];
    }
    return _navigationView;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.navigationView.frame))];
        _scrollView.pagingEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, 1130 - ScreenHeight);
        
    }
    return _scrollView;
}


-(CreateShareHeardView *)createShareHeardView{
    if (_createShareHeardView == nil) {
        _createShareHeardView = [[CreateShareHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    }
    return _createShareHeardView;
}

-(ShareCopyView *)shareCopyView{
    if (_shareCopyView == nil) {
        _shareCopyView = [[ShareCopyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.createShareHeardView.frame), ScreenWidth, 160)];
    }
    return _shareCopyView;
}

-(SharePicView *)sharePicView{
    if (_sharePicView == nil) {
        _sharePicView = [[SharePicView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareCopyView.frame), ScreenWidth, 251)];
        [_sharePicView setDelegate:self];
    }
    return _sharePicView;
}

-(SharetoTextView *)sharetoTextView{
    if (_sharetoTextView == nil) {
        _sharetoTextView = [[SharetoTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sharePicView.frame), ScreenWidth, 152)];
        [_sharetoTextView setDelegate:self];
    }
    return _sharetoTextView;
}

-(void)setModel:(GoodsDetailModel *)model{
    _model = model;
    
    [self.createShareHeardView setShareHeardString:[NSString stringWithFormat:@"分享奖励¥%@", model.commissionRate]];
    
    [self.sharePicView setDataSoucreArray:model.smallImages];
}

-(void)setShareString:(NSString *)shareString{
    [self.shareCopyView setLinkString:shareString];
}

-(GenerateImageView *)generateImageView{
    if(_generateImageView == nil){
        
        _generateImageView = [[GenerateImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 534)];
    }
    return _generateImageView;
}

@end
