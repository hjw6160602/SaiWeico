//
//  RexExResult.h
//  新浪微博
//
//  Created by shoule on 15/7/10.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExResult : NSObject
/**
 *  匹配到的字符串
 */
@property (nonatomic, copy) NSString *string;
/**
 *  匹配到的范围
 */
@property (nonatomic, assign) NSRange range;

/**
 *  这个结果是否为表情
 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
