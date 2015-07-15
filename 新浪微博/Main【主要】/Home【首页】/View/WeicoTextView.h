//
//  WeicoTextView.h
//  新浪微博
//
//  Created by shoule on 15/7/15.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeicoTextView : UITextView
@property (nonatomic, strong) UIViewController *parentVC;
/** 所有的特殊字符串(里面存放着Special) */
@property (nonatomic, strong) NSArray *specialsArray;
@end
