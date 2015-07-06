//
//  User.m
//  新浪微博
//
//  Created by shoule on 15/6/30.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

@end
