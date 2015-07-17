//
//  WeicoOriginalView.m
//  新浪微博
//
//  Created by shoule on 15/7/16.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoOriginalView.h"
#import "WeicoOriginalFrame.h"
#import "UIImage+Extension.h"
#import "NSString+Extension.h"
#import "Weico.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "WeicoPhotosView.h"
#import "WeicoTextView.h"
#import "Const.h"

@interface WeicoOriginalView()
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 正文 */
@property (nonatomic, weak) WeicoTextView *textView;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图相册 */
@property (nonatomic, weak) WeicoPhotosView *photosView;
@end

@implementation WeicoOriginalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = WeicoOrginalNameFont;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 2.正文（内容）
        WeicoTextView *textView = [[WeicoTextView alloc] init];
        [self addSubview:textView];
        self.textView = textView;
        
        // 3.时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor orangeColor];
        timeLabel.font = WeicoOrginalTimeFont;
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 4.来源
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.textColor = [UIColor lightGrayColor];
        sourceLabel.font = WeicoOrginalSourceFont;
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        // 5.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 6.会员图标
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [self addSubview:vipView];
        self.vipView = vipView;
        
        // 7.配图相册
        WeicoPhotosView *photosView = [[WeicoPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

- (void)setOriginalFrame:(WeicoOriginalFrame *)originalFrame
{
    _originalFrame = originalFrame;
    
    self.frame = originalFrame.frame;
    
    // 取出微博数据
    Weico *weico = originalFrame.weico;
    // 取出用户数据
    User *user = weico.user;
    
    // 1.昵称
    self.nameLabel.text = user.name;
    self.nameLabel.frame = originalFrame.nameFrame;
    if (user.isVip) { // 会员
        self.nameLabel.textColor = [UIColor orangeColor];
        self.vipView.hidden = NO;
        self.vipView.frame = originalFrame.vipFrame;
        self.vipView.image = [UIImage imageWithName:[NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank]];
    } else {
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    // 2.正文（内容）
    self.textView.attributedText = weico.attributedText;
    self.textView.frame = originalFrame.textFrame;

    // 3.时间
    NSString *time = weico.created_at;
    self.timeLabel.text = time; // 刚刚 --> 1分钟前 --> 10分钟前
    CGFloat timeX = CGRectGetMinX(self.nameLabel.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLabel.frame) + WeicoCellInset * 0.5;
    CGSize timeSize = [time sizeWithFont:WeicoOrginalTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
    self.sourceLabel.text = weico.source;
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + WeicoCellInset;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [weico.source sizeWithFont:WeicoOrginalSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 5.头像
    self.iconView.frame = originalFrame.iconFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    
    // 6.配图相册
    if (weico.pic_urls.count) { // 有配图
        self.photosView.frame = originalFrame.photosFrame;
        self.photosView.photos = weico.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
}
@end
