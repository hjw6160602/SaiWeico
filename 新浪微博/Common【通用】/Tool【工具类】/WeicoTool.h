//
//  WeicoTool.h
//  新浪微博
//
//  Created by shoule on 15/7/22.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//
//  微博业务类：处理跟微博相关的一切业务，比如加载微博数据、发微博、删微博

#import <Foundation/Foundation.h>
#import "BaseTool.h"
#import "HomeWeicoParam.h"
#import "HomeWeicoResult.h"
#import "SendWeicoParam.h"
#import "SendWeicoResult.h"

@class CommentParam,CommentResult;
@class SendWeicoParam,SendWeicoResult;

@interface WeicoTool : BaseTool

/**
 *  加载首页的微博数据
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)homeWeicoWithParam:(HomeWeicoParam *)param success:(void (^)(HomeWeicoResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  发没有图片的微博
 *
 *  @param param   请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)sendWeicoWithParam:(SendWeicoParam *)param success:(void (^)(SendWeicoResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  加载评论数据
 */
+ (void)commentsWithParam:(CommentParam *)param success:(void (^)(CommentResult *))success failure:(void (^)(NSError *))failure;

@end
