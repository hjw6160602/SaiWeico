//
//  WeicoRetweetedFrame.m
//  新浪微博
//
//  Created by shoule on 15/7/17.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoRetweetedFrame.h"
#import "WeicoPhotosView.h"
#import "Weico.h"
#import "Const.h"

@implementation WeicoRetweetedFrame

- (void)setRetweetedWeico:(Weico *)retweetedWeico{
    _retweetedWeico = retweetedWeico;
    
    /** 被转发微博正文 */
//    CGFloat retweetContentX = WeicoCellMargin;
//    CGFloat retweetContentY = WeicoCellMargin;
//    CGFloat maxW = SCREEN_WIDTH - 2 * WeicoCellMargin;
//    CGSize retweetContentSize = [retweetedWeico.retweetedAttributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat textX = WeicoCellMargin;
    CGFloat textY = WeicoCellMargin * 0.5;
    CGFloat maxW = SCREEN_WIDTH - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [retweetedWeico.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.retweetContentLabelF = (CGRect){{textX, textY}, textSize};
    
    /** 被转发微博配图 */
    CGFloat retweetH = 0;
    if (retweetedWeico.pic_urls.count) { // 转发微博有配图
        CGFloat retweetPhotosX = textX;
        CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + WeicoCellMargin;
        CGSize retweetPhotosSize = [WeicoPhotosView sizeWithCount:(int)retweetedWeico.pic_urls.count];
        self.retweetPhotoViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
        
        retweetH = CGRectGetMaxY(self.retweetPhotoViewF) +WeicoCellMargin;
    } else { // 转发微博没有配图
        retweetH = CGRectGetMaxY(self.retweetContentLabelF) + WeicoCellMargin;
    }
    
    /** 被转发微博整体 */
    CGFloat retweetX = 0;
    CGFloat retweetY = 0;
    CGFloat retweetW = SCREEN_WIDTH;
    self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
}

@end
