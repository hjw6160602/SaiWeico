//
//  WeicoRetweetedFrame.h
//  新浪微博
//
//  Created by shoule on 15/7/17.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Weico;

@interface WeicoRetweetedFrame : NSObject

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotoViewF;

/** 转发微博的数据 */
@property (nonatomic, strong) Weico *retweetedWeico;


@end
