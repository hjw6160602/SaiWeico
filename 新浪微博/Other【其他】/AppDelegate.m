//
//  AppDelegate.m
//  新浪微博
//
//  Created by shoule on 15/6/25.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIWindow+Extension.h"
#import "SDWebImageManager.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //如果之前登陆成功过，切换控制器
    if ([AccountTool account]) [self.window switchRootViewController];
    
    //IOS8下注册Badge
//    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
//    if (sysVersion>=8.0) {
//        UIUserNotificationType type = UIUserNotificationTypeBadge;
//        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
//        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
//    }
    return YES;
}

/**
 *  当app进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */

    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    
    /**
     1.定义变量UIBackgroundTaskIdentifier task
     2.执行右边的代码
     [application beginBackgroundTaskWithExpirationHandler:^{
     // 当申请的后台运行时间已经结束（过期），就会调用这个block
     
     // 赶紧结束任务
     [application endBackgroundTask:task];
     }];
     3.将右边方法的返回值赋值给task
     */
    
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *Manager = [SDWebImageManager sharedManager];
    // 1.取消下载
    [Manager cancelAll];
    
    // 2.清除内存中的所有图片
//    [Manager.imageCache clearMemory];
}
@end
