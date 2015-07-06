//
//  TabBar.h
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

#warning 因为TabBar继承自UITabBar，所以称为TabBar的代理，也必须实现UITabBar的代理协议
@protocol TabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar

@property (nonatomic, weak) id<TabBarDelegate> delegate;

@end
