//
//  WeicoView.m
//  新浪微博
//
//  Created by shoule on 15/7/20.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoView.h"
#import "WeicoTextView.h"
#import "IconView.h"
#import "WeicoPhotosView.h"
#import "WeicoToolBar.h"
#import "Weico.h"
#import "WeicoFrame.h"
#import "Const.h"
#import "NSString+Extension.h"

@interface WeicoView()

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

/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) WeicoTextView *retweetContentTextView;
/** 转发配图 */
@property (nonatomic, weak) WeicoPhotosView *retweetPhotosView;

/** 工具条 */
@property (nonatomic, weak) WeicoToolBar *toolbar;
@end

@implementation WeicoView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initOriginal];
        [self initRepost];
        [self initToolBar];
    }
    return self;
}
- (void)initOriginal{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    //originalView.y+=10;
    originalView.backgroundColor = [UIColor whiteColor];
    [self addSubview:originalView];
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

- (void)initRepost{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = HJWColor(247, 247, 247);
    [self addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    WeicoTextView *retweetContentTextView = [[WeicoTextView alloc] init];
    //retweetContentLabel.numberOfLines = 0;
    retweetContentTextView.font = WeicoRetweetedTextFont;
    retweetContentTextView.textColor = HJWColor(51, 51, 51);
    [retweetView addSubview:retweetContentTextView];
    self.retweetContentTextView = retweetContentTextView;
    
    /** 转发微博配图 */
    WeicoPhotosView *retweetPhotosView = [[WeicoPhotosView alloc] init];
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
}

- (void)initToolBar{
    WeicoToolBar *toolbar = [WeicoToolBar toolbar];
    [self addSubview:toolbar];
    self.toolbar = toolbar;
}

/*  WeicoFrame的set方法  */
- (void)setWeicoFrame:(WeicoFrame *)weicoFrame
{
    _weicoFrame = weicoFrame;
    
    Weico *weico = weicoFrame.weico;
    User *user = weico.user;
    
    /** 原创微博整体 */
    self.originalView.frame = weicoFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = weicoFrame.iconViewF;
    self.iconView.user = user;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = weicoFrame.vipViewF;
        
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        
        self.nameLabel.textColor = WEICO_CONTENT_COLOR;
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (weico.pic_urls.count) {
        self.photosView.frame = weicoFrame.photoViewF;
        self.photosView.photos = weico.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = weicoFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = weico.show_time;
    CGFloat timeX = weicoFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(weicoFrame.nameLabelF) + 6;
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
    self.contentTextView.frame = weicoFrame.contentLabelF;
    
    /** 被转发的微博 */
    if (weico.retweeted_status) {
        //将转发微博的正文赋值为 用户名 + 正文
        NSString *retweet_text = weico.retweeted_status.text;
        weico.retweeted_status.text = [NSString stringWithFormat:@"@%@:%@",weico.retweeted_status.user.name,retweet_text];
        
        Weico *retweeted_weico = weico.retweeted_status;
        
        self.retweetView.hidden = NO;
        /** 被转发的微博整体 */
        self.retweetView.frame = weicoFrame.retweetViewF;
        
        //将转发正文重新赋值为原始的text
        weico.retweeted_status.text = retweet_text;
        self.retweetContentTextView.attributedText = weico.retweetedAttributedText;
        self.retweetContentTextView.frame = weicoFrame.retweetContentLabelF;
        
        /** 被转发的微博配图 */
        if (retweeted_weico.pic_urls.count) {
            self.retweetPhotosView.frame = weicoFrame.retweetPhotoViewF;
            self.retweetPhotosView.photos = retweeted_weico.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }
    
    /** 工具条 */
    self.toolbar.frame = weicoFrame.toolbarF;
    self.toolbar.weico = weico;
}

@end
