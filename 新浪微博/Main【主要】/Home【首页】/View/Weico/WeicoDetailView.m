//
//  WeicoDetailView.m
//  新浪微博
//
//  Created by shoule on 15/7/16.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoDetailView.h"
#import "WeicoOriginalFrame.h"
#import "WeicoRetweetedFrame.h"
#import "WeicoDetailFrame.h"
#import "UIImage+Extension.h"
#import "WeicoOriginalView.h"
#import "WeicoRetweedtedView.h"

@interface WeicoDetailView()
@property (nonatomic, weak) WeicoOriginalView *originalView;
@property (nonatomic, weak) WeicoRetweedtedView *retweetedView;
@end

@implementation WeicoDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { // 初始化子控件
//        self.userInteractionEnabled = YES;
//        self.image = [UIImage resizedImage:@"timeline_card_top_background"];
        
        // 1.添加原创微博
        WeicoOriginalView *originalView = [[WeicoOriginalView alloc] init];
        self.originalView = originalView;
        [self addSubview:_originalView];
        
        // 2.添加转发微博
        WeicoRetweedtedView *retweetedView = [[WeicoRetweedtedView alloc] init];
        self.retweetedView = retweetedView;
        [self addSubview:_retweetedView];
    }
    return self;
}

- (void)setDetailFrame:(WeicoDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    self.frame = detailFrame.frame;
    // 1.原创微博的frame数据
    self.originalView.originalFrame = detailFrame.OriginalFrame;
    
    // 2.原创转发的frame数据
    if (detailFrame.RetweetedFrame) {
        self.retweetedView.retweetedFrame = detailFrame.RetweetedFrame;
    }
}

@end
