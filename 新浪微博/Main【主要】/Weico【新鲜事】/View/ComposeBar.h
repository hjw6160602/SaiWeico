//
//  ComposeBar.h
//  新浪微博
//
//  Created by shoule on 15/7/10.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HWComposeToolbarButtonTypeCamera, // 拍照
    HWComposeToolbarButtonTypePicture, // 相册
    HWComposeToolbarButtonTypeMention, // @
    HWComposeToolbarButtonTypeTrend, // #
    HWComposeToolbarButtonTypeEmotion // 表情
} ComposeToolbarButtonType;

@interface ComposeBar : UIToolbar

@end
