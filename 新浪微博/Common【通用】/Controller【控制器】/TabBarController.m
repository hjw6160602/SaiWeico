//
//  TabBarController.m
//  新浪微博
//
//  Created by shoule on 15/6/25.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "TabBarController.h"
#import "TabBar.h"
#import "WeicoController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - HWTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar
{
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    WeicoController *weicoController = [storybord instantiateViewControllerWithIdentifier:@"WeicoController"];
    [self presentViewController:weicoController animated:YES completion:nil];
}

@end
