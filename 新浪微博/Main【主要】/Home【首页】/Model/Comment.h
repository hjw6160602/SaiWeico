//
//  Comment.h
//  新浪微博
//
//  Created by shoule on 15/7/21.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User,Weico,Comment;

@interface Comment : NSObject

/*created_at	string	评论创建时间*/
@property (nonatomic, strong) NSString * created_at;
/*idstr         string	字符串型的评论ID*/
@property (nonatomic, strong) NSString * idstr;
/*text          string	评论的内容*/
@property (nonatomic, strong) NSString * text;
/*source        string	评论的来源*/
@property (nonatomic, strong) NSString * source;
/*user          object	评论作者的用户信息字段 详细*/
@property (nonatomic, strong) User     * user;
/*status        object	评论的微博信息字段 详细*/
@property (nonatomic, strong) Weico    * weico ;

/*mid           string	评论的MID*/
//@property (nonatomic, strong) NSString *mid;
/*reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段*/
//@property (nonatomic, strong) Comment* reply_comment ;

@end
