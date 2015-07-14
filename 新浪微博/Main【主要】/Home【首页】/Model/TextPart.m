//
//  TextPart.m
//  新浪微博
//
//  Created by shoule on 15/7/14.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "TextPart.h"

@implementation TextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}

@end
