//
//  Comment.m
//  新浪微博
//
//  Created by shoule on 15/7/21.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "Comment.h"
#import "NSDate+Extension.h"

@implementation Comment

/**	show_time	评论显示时间 get方法*/
- (NSString *)show_time
{
    return [NSDate showTimeWithCreateTime:_created_at];
}


@end
