//
//  NavigationController.m
//  微信
//
//  Created by shoule on 15/6/24.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "NavigationController.h"
#import "HJWExtension.h"

@implementation NavigationController

+ (void)initialize{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // 设置导航样式
    UINavigationBar *NaviBar = [UINavigationBar appearance];
    [NaviBar setBackgroundColor:HJW_GLOBLE_BG];
}

-(void)viewDidLoad{
    _HomeItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _MessageItem.selectedImage =  [[UIImage imageNamed:@"tabbar_message_center_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _DiscoverItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _ProfileItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HJWColor(125, 125, 125);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = HJWColor(255, 130, 0);
    selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    [self.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        //viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
        // 设置右边的更多按钮
        //viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    [super pushViewController:viewController animated:animated];
}

@end
