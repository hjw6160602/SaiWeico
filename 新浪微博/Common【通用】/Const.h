//
//  Const.h
//  新浪微博
//
//  Created by shoule on 15/7/8.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#ifndef _____Const_h
#define _____Const_h

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

#ifdef DEBUG  // 调试状态
// 打开LOG功能
#define HJWLog(...) NSLog(__VA_ARGS__)
#else // 发布状态
// 关闭LOG功能
#define HJWLog(...)
#endif

// 颜色
#define HJWColor(R, G, B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]

// 全局颜色
#define HJW_GLOBLE_BG [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.3]


// 随机色
#define HJWRandomColor HJWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif
