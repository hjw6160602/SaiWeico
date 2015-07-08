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


/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSString *mbtype = [NSString stringWithFormat:@"%d",self.mbtype];
    NSString *mbrank = [NSString stringWithFormat:@"%d",self.mbrank];
    NSString *verified_type = [NSString stringWithFormat:@"%d",self.verified_type];
    
    [encoder encodeObject:self.idstr forKey:@"idstr"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.profile_image_url forKey:@"profile_image_url"];
    [encoder encodeObject:mbtype forKey:@"mbtype"];
    [encoder encodeObject:mbrank forKey:@"mbrank"];
    [encoder encodeObject:verified_type forKey:@"verified_type"];
    
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.idstr = [decoder decodeObjectForKey:@"idstr"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.profile_image_url = [decoder decodeObjectForKey:@"profile_image_url"];
        self.mbtype = [[decoder decodeObjectForKey:@"mbtype"]intValue];
        self.mbrank = [[decoder decodeObjectForKey:@"mbrank"]intValue];
        self.verified_type = [[decoder decodeObjectForKey:@"verified_type"]intValue];
    }
    return self;
}

@end
