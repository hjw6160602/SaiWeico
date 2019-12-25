//
//  WeicoPhotosView.h
//  新浪微博
//
//  Created by shoule on 15/7/2.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeicoPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;
@end
