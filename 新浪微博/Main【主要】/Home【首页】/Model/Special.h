//
//  Special.h
//  新浪微博
//
//  Created by shoule on 15/7/15.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Special : NSObject

/** 这段特殊文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段特殊文字的范围 */
@property (nonatomic, assign) NSRange range;

@end
