//
//  WeicoFrame.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoFrame.h"
#import "Weico.h"
#import "WeicoPhotosView.h"
#import <UIKit/UIKit.h>

@implementation WeicoFrame

- (void)setWeico:(Weico *)weico
{
    _weico = weico;
    
    User *user = weico.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = WeicoCellBorderW;
    CGFloat iconY = WeicoCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + WeicoCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:WeicoCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + WeicoCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + WeicoCellBorderW;
    CGSize timeSize = [self sizeWithText:weico.created_at font:WeicoCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + WeicoCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:weico.source font:WeicoCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + WeicoCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [self sizeWithText:weico.text font:WeicoCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originalH = 0;
    if(weico.pic_urls.count){
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + WeicoCellBorderW;
        CGSize photosSize = [WeicoPhotosView sizeWithCount:(int)weico.pic_urls.count];
        self.photoViewF = (CGRect){{photosX, photosY}, photosSize};
        originalH = CGRectGetMaxY(self.photoViewF) + WeicoCellBorderW;
    } else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + WeicoCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = WeicoCellBorderW;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolbarY = 0;
    /* 被转发微博 */
    if (weico.retweeted_status) {
        Weico *retweeted_status = weico.retweeted_status;
        User *retweeted_status_user = retweeted_status.user;
        
        /** 被转发微博正文 */
        CGFloat retweetContentX = WeicoCellBorderW;
        CGFloat retweetContentY = WeicoCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [self sizeWithText:retweetContent font:WeicoCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + WeicoCellBorderW;
            CGSize retweetPhotosSize = [WeicoPhotosView sizeWithCount:(int)retweeted_status.pic_urls.count];
            self.retweetPhotoViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotoViewF) +WeicoCellBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + WeicoCellBorderW;
        }
        
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolbarY = CGRectGetMaxY(self.retweetViewF);
    } else {
        toolbarY = CGRectGetMaxY(self.originalViewF);
    }
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);

}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

@end
