//
//  Account.m
//  新浪微博
//
//  Created by shoule on 15/6/25.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "Account.h"

@implementation Account

singleton_implementation(Account);

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    Account *account = [self sharedAccount];
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    return account;
    
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.name forKey:@"name"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
