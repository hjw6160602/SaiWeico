//
//  TabBarItem.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "TabBarItem.h"
#import "UIView+Extension.h"

@implementation TabBarItem

- (void)setTitlePositionAdjustment:(UIOffset)adjustment{
    UIButton *plusBtn = [[UIButton alloc] init];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    UIImageView *imageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_compose_button"] highlightedImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"]];
    self.image = imageView.image;
//    self.size = plusBtn.currentBackgroundImage.size;
//    [self addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:plusBtn];
//    self.plusBtn = plusBtn;
}
- (UIOffset)titlePositionAdjustment{
    UIOffset offSet = {0,0};
    return offSet;
}

@end
