//
//  CommentResult.m
//  新浪微博
//
//  Created by shoule on 15/7/21.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "CommentResult.h"
#import "Comment.h"

@implementation CommentResult
- (NSDictionary *)objectClassInArray
{
    return @{@"comments" : [Comment class]};
}
@end
