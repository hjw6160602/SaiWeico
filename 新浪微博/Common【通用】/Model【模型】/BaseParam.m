//
//  BaseParam.m
//  新浪微博
//
//  Created by shoule on 15/7/21.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "BaseParam.h"
#import "AccountTool.h"

@implementation BaseParam
- (id)init
{
    if (self = [super init]) {
        self.access_token = [AccountTool account].access_token;
    }
    return self;
}

+ (instancetype)param
{
    return [[self alloc] init];
}
@end
