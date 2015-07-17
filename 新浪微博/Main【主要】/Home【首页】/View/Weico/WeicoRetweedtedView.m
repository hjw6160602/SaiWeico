//
//  WeicoRetweedtedView.m
//  新浪微博
//
//  Created by shoule on 15/7/17.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoRetweedtedView.h"
#import "WeicoTextView.h"
#import "WeicoPhotosView.h"
#import "Const.h"
#import "UIImage+Extension.h"
#import "WeicoRetweetedFrame.h"
#import "Weico.h"

@interface WeicoRetweedtedView()
/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) WeicoTextView *textView;
/** 转发配图 */
@property (nonatomic, weak) WeicoPhotosView *photosView;
@end

@implementation WeicoRetweedtedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_retweet_background"];
        
        /** 转发微博整体 */
        UIView *retweetView = [[UIView alloc] init];
        self.retweetView = retweetView;
        
        /** 转发微博正文 + 昵称 */
        WeicoTextView *textView = [[WeicoTextView alloc] init];
        //retweetContentLabel.numberOfLines = 0;
        textView.font = WeicoRetweetedTextFont;
        textView.textColor = HJWColor(51, 51, 51);
        [retweetView addSubview:textView];
        self.textView = textView;
        
        /** 转发微博配图 */
        WeicoPhotosView *photosView = [[WeicoPhotosView alloc] init];
        [retweetView addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

- (void)setRetweetedFrame:(WeicoRetweetedFrame *)retweetedFrame{
    _retweetedFrame = retweetedFrame;
    
    self.frame = retweetedFrame.retweetViewF;
    
    // 取出微博数据
    Weico *retweetedWeico = retweetedFrame.retweetedWeico;
    
    // 1.正文（内容）
    self.textView.attributedText = retweetedWeico.attributedText;
    
    self.textView.frame = retweetedFrame.retweetContentLabelF;
    
    // 2.配图相册
    if (retweetedWeico.pic_urls.count) { // 有配图
        self.photosView.frame = retweetedFrame.retweetPhotoViewF;
        self.photosView.photos = retweetedWeico.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    // 3.工具条
//    self.toolbar.frame = retweetedFrame.toolbarFrame;
//    self.toolbar.status = retweetedFrame.retweetedStatus;
}

@end
