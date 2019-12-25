//
//  WeicoTool.m
//  新浪微博
//
//  Created by shoule on 15/7/22.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoTool.h"
#import "HttpTool.h"
#import "CommentParam.h"
#import "CommentResult.h"
#import "API.h"

@implementation WeicoTool

+ (void)homeWeicoWithParam:(HomeWeicoParam *)param success:(void (^)(HomeWeicoResult *))success failure:(void (^)(NSError *))failure
{
    [self getWithUrl:GET_HOME_WEICO param:param resultClass:[HomeWeicoResult class] success:success failure:failure];
}

+ (void)sendWeicoWithParam:(SendWeicoParam *)param success:(void (^)(SendWeicoResult *))success failure:(void (^)(NSError *))failure
{
    [self postWithUrl:POST_SEND_WEICO param:param resultClass:[SendWeicoResult class] success:success failure:failure];
}

+ (void)commentsWithParam:(CommentParam *)param success:(void (^)(CommentResult *))success failure:(void (^)(NSError *))failure
{
    [self getWithUrl:GET_COMMENT
               param:param
         resultClass:[CommentResult class]
             success:success failure:failure];
}

@end
