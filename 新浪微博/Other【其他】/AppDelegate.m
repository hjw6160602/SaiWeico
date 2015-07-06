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
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *Manager = [SDWebImageManager sharedManager];
    // 1.取消下载
    [Manager cancelAll];
    
    // 2.清除内存中的所有图片
    [Manager.imageCache clearMemory];
}
@end
