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
#import "IconView.h"
#import "UIImageView+WebCache.h"
#import "WeicoPhotosView.h"
#import "WeicoTextView.h"
#import "Const.h"

@interface WeicoOriginalView()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) IconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) WeicoPhotosView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) WeicoTextView *contentTextView;
@end

@implementation WeicoOriginalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 原创微博整体 */
        UIView *originalView = [[UIView alloc] init];
        //originalView.y+=10;
        originalView.backgroundColor = [UIColor whiteColor];
        self.originalView = originalView;
        
        /** 头像 */
        IconView *iconView = [[IconView alloc] init];
        
        [originalView addSubview:iconView];
        self.iconView = iconView;
        
        /** 会员图标 */
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [originalView addSubview:vipView];
        self.vipView = vipView;
        
        /** 配图 */
        WeicoPhotosView *photosView = [[WeicoPhotosView alloc] init];
        [originalView addSubview:photosView];
        self.photosView = photosView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = WeicoOrginalNameFont;
        [originalView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = WeicoOrginalTimeFont;
        timeLabel.textColor = [UIColor lightGrayColor];
        [originalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = WeicoOrginalSourceFont;
        sourceLabel.textColor = [UIColor lightGrayColor];
        [originalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 正文 */
        WeicoTextView *contentTextView = [[WeicoTextView alloc] init];
        contentTextView.font = WeicoOrginalTextFont;
        //contentTextView.numberOfLines = 0;
        [originalView addSubview:contentTextView];
        self.contentTextView = contentTextView;
    }
    return self;
}

- (void)setOriginalFrame:(WeicoOriginalFrame *)originalFrame
{
    _originalFrame = originalFrame;
    
    Weico *weico = originalFrame.weico;
    User *user = weico.user;
    
    /** 原创微博整体 */
    self.originalView.frame = originalFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = originalFrame.iconViewF;
    self.iconView.user = user;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = originalFrame.vipViewF;
        
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        
        self.nameLabel.textColor = WEICO_CONTENT_COLOR;
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (weico.pic_urls.count) {
        self.photosView.frame = originalFrame.photoViewF;
        self.photosView.photos = weico.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = originalFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = weico.show_time;
    CGFloat timeX = originalFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(originalFrame.nameLabelF) + 6;
    CGSize timeSize = [time sizeWithFont:WeicoOrginalTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + 6;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [weico.source sizeWithFont:WeicoOrginalSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = weico.source;
    
    /** 正文 */
    self.contentTextView.attributedText = weico.attributedText;
    self.contentTextView.frame = originalFrame.contentLabelF;
}
@end
