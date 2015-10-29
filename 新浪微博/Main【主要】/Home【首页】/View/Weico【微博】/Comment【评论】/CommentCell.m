//
//  CommentCell.m
//  新浪微博
//
//  Created by shoule on 15/8/6.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "WeicoPhotosView.h"
#import "WeicoTextView.h"
#import "NSString+Extension.h"
#import "User.h"
#import "IconView.h"
#import "Const.h"

@interface CommentCell()

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
//@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) WeicoTextView *contentTextView;

@end

@implementation CommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    nameLabel.font = WeicoOrginalNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = WeicoOrginalTimeFont;
    timeLabel.textColor = [UIColor lightGrayColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 正文 */
    WeicoTextView *contentTextView = [[WeicoTextView alloc] init];
    contentTextView.font = WeicoOrginalTextFont;
    //contentTextView.numberOfLines = 0;
    [originalView addSubview:contentTextView];
    self.contentTextView = contentTextView;
}

- (void)setCommentFrame:(CommentFrame *)commentFrame{
    _commentFrame = commentFrame;
    
    Comment *comment = commentFrame.comment;
    User *user = comment.user;
    
    /** 原创微博整体 */
    self.originalView.frame = commentFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = commentFrame.iconViewF;
    self.iconView.user = user;
//    self.iconView.layer.cornerRadius = self.iconView.width/2;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = commentFrame.vipViewF;
        
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        
        self.nameLabel.textColor = WEICO_CONTENT_COLOR;
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (comment.pic_urls.count) {
        self.photosView.frame = commentFrame.photoViewF;
        self.photosView.photos = comment.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = commentFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = comment.show_time;
    CGFloat timeX = commentFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(commentFrame.nameLabelF) + 6;
    CGSize timeSize = [time sizeWithFont:WeicoOrginalTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 正文 */
    self.contentTextView.attributedText = comment.attributedText;
    self.contentTextView.frame = commentFrame.contentLabelF;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
