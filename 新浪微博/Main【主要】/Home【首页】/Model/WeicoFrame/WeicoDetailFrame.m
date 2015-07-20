//
//  WeicoDetailFrame.m
//  新浪微博
//
//  Created by shoule on 15/7/16.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoDetailFrame.h"
#import "Weico.h"
#import "Const.h"
#import "WeicoOriginalFrame.h"
#import "WeicoRetweetedFrame.h"

@implementation WeicoDetailFrame
- (void)setWeico:(Weico *)weico{
    _weico = weico;
    
    // 1.计算原创微博的frame
    WeicoOriginalFrame *originalFrame = [[WeicoOriginalFrame alloc] init];
    originalFrame.weico = weico;
    self.OriginalFrame = originalFrame;
    
    // 2.计算转发微博的frame
    CGFloat h = 0;
    if (weico.retweeted_status) {
        WeicoRetweetedFrame *retweetedFrame = [[WeicoRetweetedFrame alloc] init];
        retweetedFrame.retweetedWeico = weico.retweeted_status;
        
        // 计算转发微博frame的y值
        CGRect f = retweetedFrame.retweetViewF;
        f.origin.y = CGRectGetMaxY(originalFrame.originalViewF);
        retweetedFrame.retweetViewF = f;
        
        self.RetweetedFrame = retweetedFrame;
        
        h = CGRectGetMaxY(retweetedFrame.retweetViewF);
    }
    else {
        h = CGRectGetMaxY(originalFrame.originalViewF);
    }
    
    // 自己的frame
    CGFloat x = 0;
    CGFloat y = WeicoCellMargin;
    CGFloat w = SCREEN_WIDTH;
    self.frame = CGRectMake(x, y, w, h);
}
@end
