//
//  TabBar.h
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

@protocol TabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickPlusButton:(TabBar *)tabBar;

@end

@interface TabBar : UITabBar

@property (nonatomic, weak) id<TabBarDelegate> delegate;

@end
