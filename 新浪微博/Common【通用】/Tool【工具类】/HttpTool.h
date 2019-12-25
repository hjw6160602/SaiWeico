//
//  HttpTool.h
//  新浪微博
//
//  Created by shoule on 15/7/22.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//
//  网络请求工具类：负责整个项目的所有HTTP请求

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params
    success:(void (^)(id responseObj))success
    failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id responseObj))success
     failure:(void (^)(NSError *error))failure;

@end