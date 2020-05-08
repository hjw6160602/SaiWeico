//
//  HMHomeStatusesResult.m
//  黑马微博
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HomeWeicoResult.h"
@import MJExtension;
#import "Weico.h"

@implementation HomeWeicoResult

- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [Weico class]};
}

@end
