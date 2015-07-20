//
//  WeicoOriginalFrame.m
//  新浪微博
//
//  Created by shoule on 15/7/16.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoOriginalFrame.h"
#import "WeicoPhotosView.h"
#import "Const.h"
#import "Weico.h"

@implementation WeicoOriginalFrame

- (void)setWeico:(Weico *)weico{
    _weico = weico;
    
    User *user = weico.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = WeicoCellMargin;
    CGFloat iconY = WeicoCellMargin;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + WeicoCellMargin;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:WeicoOrginalNameFont];
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
    CGSize timeSize = [self sizeWithText:weico.created_at font:WeicoOrginalTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + WeicoCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:weico.source font:WeicoOrginalSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + WeicoCellMargin/2;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [weico.attributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originalH = 0;
    if(weico.pic_urls.count){
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + 5;
        CGSize photosSize = [WeicoPhotosView sizeWithCount:(int)weico.pic_urls.count];
        self.photoViewF = (CGRect){{photosX, photosY}, photosSize};
        originalH = CGRectGetMaxY(self.photoViewF) + WeicoCellMargin;
    } else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + WeicoCellMargin;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 5;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    return [text boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs context:nil].size;
}

@end
