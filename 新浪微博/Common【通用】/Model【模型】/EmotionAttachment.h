//
//  HMEmotionAttachment.h
//  黑马微博
//
//  Created by apple on 14-7-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@interface EmotionAttachment : NSTextAttachment
@property (nonatomic, strong) Emotion *emotion;
@end
