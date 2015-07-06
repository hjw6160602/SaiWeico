//
//  UIWindow+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TabBarController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *tabBarController = [sb instantiateViewControllerWithIdentifier:@"TabBarController"];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    self.rootViewController = tabBarController;

}
@end
