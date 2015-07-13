//
//  HMEmotionAttachment.m
//  黑马微博
//
//  Created by apple on 14-7-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "EmotionAttachment.h"
#import "UIImage+Extension.h"
#import "Emotion.h"


@implementation EmotionAttachment

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    NSString *emotionPath =[NSString stringWithFormat:@"%@", emotion.png];
    
    self.image = [UIImage imageWithName:emotionPath];
}

@end
