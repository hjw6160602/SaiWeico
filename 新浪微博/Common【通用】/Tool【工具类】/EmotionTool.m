//
//  EmotionTool.m
//  黑马微博
//
//  Created by apple on 14-7-17.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#define RecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

#import "EmotionTool.h"
#import "Emotion.h"
#import "HJWExtension.h"

@implementation EmotionTool

/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;

/** 最近表情 */
static NSMutableArray *_recentEmotions;

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        //NSString *plist = [[NSBundle mainBundle] pathForResource:@"" ofType:nil];
        
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"default/info.plist" ofType:nil];
        
        _defaultEmotions = [Emotion objectArrayWithFile:plist];
    }
    
    return _defaultEmotions;
    
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emoji/info.plist" ofType:nil];
        _emojiEmotions = [Emotion objectArrayWithFile:plist];
    }
    
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"lxh/info.plist" ofType:nil];
        _lxhEmotions = [Emotion objectArrayWithFile:plist];
    }
    
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 去沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    
    return _recentEmotions;
}

// Emotion -- 戴口罩 -- Emoji的plist里面加载的表情
+ (void)addRecentEmotion:(Emotion *)emotion
{
    // 加载最近的表情数据
    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 添加最新的表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RecentFilepath];
}

+ (Emotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return nil;
    
    __block Emotion *foundEmotion = nil;
    
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(Emotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(Emotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}

//+ (Emotion *)emotionWithChs:(NSString *)chs
//{
//    NSArray *defaults = [self defaultEmotions];
//    for (Emotion *emotion in defaults) {
//        if ([emotion.chs isEqualToString:chs]) return emotion;
//    }
//    
//    NSArray *lxhs = [self lxhEmotions];
//    for (Emotion *emotion in lxhs) {
//        if ([emotion.chs isEqualToString:chs]) return emotion;
//    }
//    return nil;
//}
@end
