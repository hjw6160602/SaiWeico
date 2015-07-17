//
//  WeicoFrame.h
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
//  一个WeicoFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型Weico
// 昵称字体

@class Weico,WeicoDetailFrame;

@interface WeicoFrame : NSObject

@property (nonatomic, strong) WeicoDetailFrame *detailF;
/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 微博数据 */
@property (nonatomic, strong) Weico *weico;

@property (nonatomic, assign) CGRect frame ;

@end
