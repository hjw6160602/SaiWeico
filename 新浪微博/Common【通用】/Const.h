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

// 通知中心
#define HJWNotificationCenter [NSNotificationCenter defaultCenter]

// 颜色
#define HJWColor(R, G, B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]

// 全局颜色
#define WEICO_CONTENT_COLOR [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]


// 随机色
#define HJWRandomColor HJWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 是否为4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)

// 导航栏标题的字体
#define NavigationTitleFont [UIFont boldSystemFontOfSize:20]

// 应用信息
#define AppKey @"1566588143"
#define AppSecret @"dafb97bdaecbcfd993f7d81b4edd5603"


// cell的计算参数
// cell之间的间距
#define WeicoCellMargin 10

// cell的内边距
#define WeicoCellInset 5

// 原创微博昵称字体
#define WeicoOrginalNameFont [UIFont systemFontOfSize:13]
// 原创微博时间字体
#define WeicoOrginalTimeFont [UIFont systemFontOfSize:11]
// 原创微博来源字体
#define WeicoOrginalSourceFont WeicoOrginalTimeFont
// 原创微博正文字体
#define WeicoOrginalTextFont [UIFont systemFontOfSize:16]
// 富文本字体
#define WeicoRichTextFont [UIFont systemFontOfSize:16]

// 转发微博昵称字体
#define WeicoRetweetedNameFont WeicoOrginalNameFont
// 转发微博正文字体
#define WeicoRetweetedTextFont WeicoOrginalTextFont


// 转发微博正文字体
#define WeicoHighTextColor HJWColor(255, 126, 157)
#define WeicoHighBGColor HJWColor(255, 180, 184)
#define GLOBLE_BG HJWColor(245, 245, 245)

/** 表情相关 */
// 表情的最大行数
#define EmotionMaxRows 3
// 表情的最大列数
#define EmotionMaxCols 7
// 每页最多显示多少个表情
#define EmotionMaxCountPerPage (EmotionMaxRows * EmotionMaxCols - 1)

// 通知
// 表情选中的通知
#define EmotionDidSelectedNotification @"EmotionDidSelectedNotification"
// 点击删除按钮的通知
#define EmotionDidDeletedNotification @"EmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define SelectedEmotion @"SelectedEmotion"

#endif
