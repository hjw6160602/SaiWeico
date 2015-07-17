//
//  WeicoDetailFrame.h
//  新浪微博
//
//  Created by shoule on 15/7/16.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Weico, WeicoOriginalFrame, WeicoRetweetedFrame;

@interface WeicoDetailFrame : NSObject

@property (nonatomic, strong) WeicoOriginalFrame *OriginalFrame;
@property (nonatomic, strong) WeicoRetweetedFrame *RetweetedFrame;
/** 微博数据 */
@property (nonatomic, strong) Weico *weico;
/* 自己的frame*/
@property (nonatomic, assign) CGRect frame;
@end
