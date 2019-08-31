//
//  TipSearchView.m
//  ALiLikePurchase
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019 郭超. All rights reserved.
//

#import "TipSearchView.h"

#import "UILabel+HuaZhi.h"

#import "UIColor+DD.h"


@interface TipSearchView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *tipSearchView;
@property (weak, nonatomic) IBOutlet UIView *tipTopView;
@property (weak, nonatomic) IBOutlet UIView *tipBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipTopViewHeight;
- (IBAction)clearAction:(UIButton *)sender;

@end

@implementation TipSearchView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TipSearchView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    [self updateHistoryList];
    [self addHotList];
    
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

- (void)addHotList {
    NSArray *hotArray = @[@"春装", @"家居用品", @"梳妆台", @"剃须刀", @"跑步机"];
    
    CGSize orgxy=CGSizeMake(10, 50);
    
    for (int i=0; i<hotArray.count; i++) {
        
        UILabel *historyLabel=[[UILabel alloc] init];
        
        historyLabel.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        
        historyLabel.clipsToBounds = YES;
        
        historyLabel.layer.cornerRadius = 15;
        
        historyLabel.font = [UIFont fontWithName:RegularFont size:14];
        
        historyLabel.textColor = [UIColor colorWithHexString:@"666666"];
        
        historyLabel.text = [NSString stringWithFormat:@"    %@    ",hotArray[i]];
        
        orgxy = [historyLabel nextOrgin:orgxy];//适配
        
        [historyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        
        historyLabel.userInteractionEnabled=YES;
        
        [self.tipBottomView addSubview:historyLabel];
    }
}


//热门标签点击相应
-(void)tagDidCLick:(UITapGestureRecognizer *)sender
{
    UILabel *label=(UILabel *)sender.view;
    
    NSString *text =  [label.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self.delegate respondsToSelector:@selector(tapLable:)]) {
        [self.delegate tapLable:text];
    }
}

- (void)updateHistoryList {
    [self.tipTopView setHidden:NO];
    
    for (UIView *view in self.tipTopView.subviews) {
        if (view.tag == 1999) {
            [view removeFromSuperview];
        }
    }
    
    CGSize orgxy=CGSizeMake(10, 50);
    for (int i=0; i<self.historyArray.count; i++) {
        UILabel *historyLabel=[[UILabel alloc] init];
        historyLabel.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        historyLabel.clipsToBounds = YES;
        historyLabel.layer.cornerRadius = 15;
        historyLabel.tag = 1999;
        historyLabel.font = [UIFont systemFontOfSize:15];
        historyLabel.textColor = [UIColor colorWithHexString:@"666666"];
        historyLabel.text=[NSString stringWithFormat:@"   %@   ", self.historyArray[i]];
        orgxy=[historyLabel nextOrgin:orgxy];//适配
        [historyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        historyLabel.userInteractionEnabled=YES;
        [self.tipTopView addSubview:historyLabel];
    }
    self.tipTopViewHeight.constant = orgxy.height + 40 + 20;
    
    if (self.historyArray.count == 0) {
        self.tipTopViewHeight.constant = 0;
        [self.tipTopView setHidden:YES];
    }
}



- (IBAction)clearAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clearList)]) {
        [self.delegate clearList];
    }
    
}

-(void)setHistoryArray:(NSMutableArray *)historyArray{
    _historyArray = historyArray;
    [self updateHistoryList];
}
@end
