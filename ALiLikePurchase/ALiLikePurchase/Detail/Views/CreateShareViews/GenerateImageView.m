//
//  GenerateImageView.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/18.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "GenerateImageView.h"
#import "GoodsDetailModel.h"
#import "UIColor+DD.h"

@interface GenerateImageView()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pirceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanViewW;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@property (weak, nonatomic) IBOutlet UIView *quanView;
@end


@implementation GenerateImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GenerateImageView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)setModel:(GoodsDetailModel *)model{
    _model = model;
    
    NSString *str = [NSString stringWithFormat:@"原价¥%@", model.zkFinalPrice];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"9A9B9D"] range:NSMakeRange(0, str.length)];
    [self.yuanLabel setAttributedText:attri];
    
    [self.yuelabel setText:[NSString stringWithFormat:@"月销%@", model.volume]];
    
    
    NSString *couponInfo = model.couponInfo;
    if (couponInfo.length > 0) {
        
        NSRange range = [couponInfo rangeOfString:@"减"];
        NSString *subString = [couponInfo substringFromIndex:(range.location +1)];
        [self.quanLabel setText:[NSString stringWithFormat:@" 劵 ¥%@ ", subString]];
        CGFloat width = [self getWidthWithText:self.quanLabel.text height:14 font:12] + 1;
        
        self.quanViewW.constant = width;
    }else{
        [self.quanView setHidden:YES];
    }
    
    
    
    [self.goodsImageView sd_setImageWithURL:[model.smallImages firstObject]];
    
    [self.titleLabel setText:model.title];
    
    [self.pirceLabel setText:[NSString stringWithFormat:@"￥%@", model.couponAfterPrice]];
    
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //过滤器恢复默认
    [filter setDefaults];
    
    //给过滤器添加数据
    NSString *string = @"http://wx.alhuigou.com/home";
    
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    //将获取到的二维码添加到imageview上
    self.codeImageView.image =[UIImage imageWithCIImage:image];
    
    
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat )font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}


@end
