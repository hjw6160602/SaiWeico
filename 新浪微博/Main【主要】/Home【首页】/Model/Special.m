//
//  Special.m
//  新浪微博
//
//  Created by shoule on 15/7/15.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "Special.h"

@implementation Special

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}

@end
