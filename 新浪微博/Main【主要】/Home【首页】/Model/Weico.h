//
//  Weico.h
//  新浪微博
//
//  Created by shoule on 15/6/30.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

// 段落样式行间距
#define LINE_SPACING 5
// 段落样式
#define HEAD_INDENT 5

@interface Weico : NSObject<NSCoding>

/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) User *user;

/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	微博的显示时间*/
@property (nonatomic, copy) NSString *show_time;

/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;


/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) Weico *retweeted_status;
@property (nonatomic, copy) NSAttributedString *retweetedAttributedText;
/**	int	转发数*/
@property (nonatomic, assign) int reposts_count;
/**	int	评论数*/
@property (nonatomic, assign) int comments_count;
/**	int	表态数*/
@property (nonatomic, assign) int attitudes_count;

@end
