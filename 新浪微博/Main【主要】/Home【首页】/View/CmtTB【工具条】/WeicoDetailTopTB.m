//
//  WeicoDetailTopTB.m
//  新浪微博
//
//  Created by shoule on 15/7/22.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoDetailTopTB.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"
#import "Const.h"
#import "Weico.h"

@interface WeicoDetailTopTB()
/** 三角形 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UIButton *retweetedButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *attitudeButton;
@property (nonatomic, weak) UIButton *selectedButton;
- (IBAction)buttonClick:(UIButton *)button;

@end

@implementation WeicoDetailTopTB

+ (instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WeicoDetailTopTB" owner:nil options:nil] lastObject];
}

- (void)drawRect:(CGRect)rect
{
    rect.origin.y = 10;
    [[UIImage resizedImage:@"statusdetail_comment_top_background"] drawInRect:rect];
}

/**
 *  从xib中加载完毕后就会调用
 */
- (void)awakeFromNib
{
    // 1.设置按钮tag
    self.retweetedButton.tag = WeicoDetailTopTBButtonTypeRetweeted;
    self.commentButton.tag = WeicoDetailTopTBButtonTypeComment;
    
    // 设置背景色
    self.backgroundColor = GLOBE_BG;
}

- (void)setDelegate:(id<WeicoDetailTopTBDelegate>)delegate
{
    _delegate = delegate;
    
    // 默认点击了评论按钮
    [self buttonClick:self.commentButton];
}

/**
 *  监听按钮点击
 */
- (IBAction)buttonClick:(UIButton *)button {
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 2.控制箭头的位置
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowView.centerX = button.centerX;
    }];
    
    // 3.通知代理
    if ([self.delegate respondsToSelector:@selector(topTB:didSelectedButton:)]) {
        [self.delegate topTB:self didSelectedButton:(WeicoDetailTBBtnType)button.tag];
    }
}

- (void)setWeico:(Weico *)weico
{
    _weico = weico;
    
    [self setupBtnTitle:self.retweetedButton count:weico.reposts_count defaultTitle:@"转发"];
    [self setupBtnTitle:self.commentButton count:weico.comments_count defaultTitle:@"评论"];
    [self setupBtnTitle:self.attitudeButton count:weico.attitudes_count defaultTitle:@"赞"];
}

/**
 *  设置按钮的文字
 *
 *  @param button       需要设置文字的按钮
 *  @param count        按钮显示的数字
 *  @param defaultTitle 数字为0时显示的默认文字
 */
- (void)setupBtnTitle:(UIButton *)button count:(int)count defaultTitle:(NSString *)defaultTitle
{
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万 %@", count / 10000.0, defaultTitle];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%d %@", count, defaultTitle];
    } else {
        defaultTitle = [NSString stringWithFormat:@"0 %@", defaultTitle];
    }
    [button setTitle:defaultTitle forState:UIControlStateNormal];
    [button setTitle:defaultTitle forState:UIControlStateSelected];
}
@end
