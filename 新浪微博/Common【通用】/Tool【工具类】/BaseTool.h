//
//  BaseTool.h
//  新浪微博
//
//  Created by shoule on 15/7/22.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//
//  最基本的业务工具类

#import <Foundation/Foundation.h>

@interface BaseTool : NSObject
+ (void)getWithUrl:(NSString *)url
             param:(id)param
       resultClass:(Class)resultClass
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure;

+ (void)postWithUrl:(NSString *)url
              param:(id)param
        resultClass:(Class)resultClass
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;
@end
