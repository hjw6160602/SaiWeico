//
//  WeicoToolBar.h
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Weico;

@interface WeicoToolBar : UIView

+ (instancetype)toolbar;
@property (nonatomic, strong) Weico *weico;

@end
