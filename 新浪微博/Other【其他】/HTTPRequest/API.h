//
//  API.h
//  新浪微博
//
//  Created by shoule on 15/7/9.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#ifndef _____API_h
#define _____API_h
/** 获取acess_token */
#define POST_ACCESS_TOKEN           @"https://api.weibo.com/oauth2/access_token"
/** 获取当前登录用户及其所关注用户的最新微博 */
#define GET_HOME_TIMELINE_WEICO     @"https://api.weibo.com/2/statuses/home_timeline.json"
/** 获取当前登录用户及其所关注用户的最新微博 */
#define GET_FRIENDS_TIMELINE_WEICO  @"https://api.weibo.com/2/statuses/friends_timeline.json"
/** 根据用户ID获取用户信息 */
#define GET_USERINFO                @"https://api.weibo.com/2/users/show.json"
/** 获取某个用户的各种消息未读数 */
#define GET_REMIND_UNREAD           @"https://rm.api.weibo.com/2/remind/unread_count.json"
/** 发送微博接口 */
#define POST_WEICO                  @"https://api.weibo.com/2/statuses/update.json"

#endif
