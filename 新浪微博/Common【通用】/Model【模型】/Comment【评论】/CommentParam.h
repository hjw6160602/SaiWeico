//
//  CommentParam.h
//  新浪微博
//
//  Created by shoule on 15/7/21.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>

//id                true	int64	需要查询的微博ID。
//since_id          false	int64	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
//max_id            false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
//count	false       int             单页返回的记录条数，默认为50。
//page	false       int             返回结果的页码，默认为1。
//filter_by_author	false	int     作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。

@interface CommentParam : NSObject

/** id	true	int64	需要查询的微博ID。*/
@property (nonatomic, copy) NSString *id;

/**	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。*/
@property (nonatomic, copy) NSString *since_id;

/** false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。*/
@property (nonatomic, strong) NSNumber *max_id;

/** false	int	单页返回的记录条数，最大不超过100，默认为20。*/
@property (nonatomic, strong) NSNumber *count;

@end
