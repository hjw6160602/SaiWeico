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

//+ (void)homeStatusesWithParam:(HMHomeStatusesParam *)param success:(void (^)(HMHomeStatusesResult *))success failure:(void (^)(NSError *))failure
//{
//    [self getWithUrl:@"https://api.weibo.com/2/statuses/home_timeline.json" param:param resultClass:[HMHomeStatusesResult class] success:success failure:failure];
//}
//
//+ (void)sendStatusWithParam:(HMSendStatusParam *)param success:(void (^)(HMSendStatusResult *))success failure:(void (^)(NSError *))failure
//{
//    [self postWithUrl:@"https://api.weibo.com/2/statuses/update.json" param:param resultClass:[HMSendStatusResult class] success:success failure:failure];
//}

+ (void)commentsWithParam:(CommentParam *)param success:(void (^)(CommentResult *))success failure:(void (^)(NSError *))failure
{
    [self getWithUrl:GET_COMMENT
               param:param
         resultClass:[CommentResult class]
             success:success failure:failure];
}

@end
