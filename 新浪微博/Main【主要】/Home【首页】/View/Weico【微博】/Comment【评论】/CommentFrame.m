//
//  CommentFrame.m
//  新浪微博
//
//  Created by shoule on 15/10/28.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import "CommentFrame.h"
#import <UIKit/UIKit.h>
#import "WeicoPhotosView.h"
#import "Comment.h"
#import "Photo.h"
#import "Const.h"

@implementation CommentFrame
//timeline_icon_unlike
- (void)setComment:(Comment *)comment{
    _comment = comment;
    
    User *user = comment.user;
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 */
    CGFloat iconWH = 40;
    CGFloat iconX = 10;
    CGFloat iconY = 15;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + WeicoCellMargin;
    CGFloat nameY = WeicoCellMargin;
    CGSize nameSize = [self sizeWithText:comment.user.name font:WeicoOrginalNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + WeicoCellMargin;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + WeicoCellMargin;
    CGSize timeSize = [self sizeWithText:comment.created_at font:WeicoOrginalTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + WeicoCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:comment.source font:WeicoOrginalSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 评论正文 */
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(self.timeLabelF) + WeicoCellMargin/2;
    CGFloat maxW = cellW - iconX - nameX;
    CGSize contentSize = [comment.attributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originalH = 0;
    if(comment.pic_urls.count){
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + 5;
        CGSize photosSize = [WeicoPhotosView sizeWithCount:(int)comment.pic_urls.count];
        self.photoViewF = (CGRect){{photosX, photosY}, photosSize};
        originalH = CGRectGetMaxY(self.photoViewF) + WeicoCellMargin;
    } else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + WeicoCellMargin;
    }
    
    /** 评论整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);

    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(240, MAXFLOAT);
    return [text boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs context:nil].size;
}

@end
