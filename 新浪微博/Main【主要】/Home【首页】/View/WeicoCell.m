//
//  WeicoCell.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//
#import "Weico.h"
#import "User.h"
#import "WeicoCell.h"
#import "WeicoFrame.h"
#import "HJWExtension.h"
#import "WeicoFrame.h"
#import "Photo.h"
#import "WeicoToolBar.h"
#import "NSString+Extension.h"
#import "WeicoPhotosView.h"
#import "UIView+Extension.h"
#import "IconView.h"


@interface WeicoCell()
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
@property (nonatomic, weak) UILabel *contentLabel;

/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) WeicoPhotosView *retweetPhotosView;

/** 工具条 */
@property (nonatomic, weak) WeicoToolBar *toolbar;

@end

@implementation WeicoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"weico";
    WeicoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WeicoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    [self.contentView addSubview:originalView];
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
    nameLabel.font = WeicoCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = WeicoCellTimeFont;
    timeLabel.textColor = [UIColor lightGrayColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = WeicoCellSourceFont;
    sourceLabel.textColor = [UIColor lightGrayColor];
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = WeicoCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)initRepost{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = HJWColor(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = WeicoCellRetweetContentFont;
    retweetContentLabel.textColor = HJWColor(51, 51, 51);
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    WeicoPhotosView *retweetPhotosView = [[WeicoPhotosView alloc] init];
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
}

- (void)initToolBar{
    WeicoToolBar *toolbar = [WeicoToolBar toolbar];
    [self.contentView addSubview:toolbar];
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
    
        self.nameLabel.textColor = [UIColor blackColor];
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
    CGSize timeSize = [time sizeWithFont:WeicoCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + 6;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [weico.source sizeWithFont:WeicoCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = weico.source;
    
    /** 正文 */
    self.contentLabel.attributedText = weico.attributedText;
    //self.contentLabel.text = weico.text;
    self.contentLabel.frame = weicoFrame.contentLabelF;
    
    /** 被转发的微博 */
    if (weico.retweeted_status) {
        Weico *retweeted_weico = weico.retweeted_status;
        User *retweeted_weico_user = retweeted_weico.user;
        
        self.retweetView.hidden = NO;
        /** 被转发的微博整体 */
        self.retweetView.frame = weicoFrame.retweetViewF;
        
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_weico_user.name, retweeted_weico.attributedText];
        self.retweetContentLabel.text = retweetContent;
        self.retweetContentLabel.frame = weicoFrame.retweetContentLabelF;
        
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
