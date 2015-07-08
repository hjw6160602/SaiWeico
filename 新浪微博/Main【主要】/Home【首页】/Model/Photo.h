//
//  Photo.h
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject <NSCoding>

/** 缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;

@end
