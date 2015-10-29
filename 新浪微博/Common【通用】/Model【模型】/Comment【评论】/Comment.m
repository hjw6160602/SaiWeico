//
//  Comment.m
//  新浪微博
//
//  Created by shoule on 15/7/21.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "Comment.h"
#import "Photo.h"
#import "TextPart.h"
#import "NSDate+Extension.h"
#import <CoreText/CoreText.h>
#import "RegexKitLite.h"
#import "EmotionTool.h"
#import "Emotion.h"
#import "Special.h"
#import "Const.h"

@implementation Comment

/**	show_time	评论显示时间 get方法*/
- (NSString *)show_time
{
    return [NSDate showTimeWithCreateTime:_created_at];
}

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [Photo class]};
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    // 利用text生成attributedText
    self.attributedText = [self attributedTextWithText:text isRetweet:NO];
}

/**
 *  普通文字 --> 属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
- (NSAttributedString *)attributedTextWithText:(NSString *)text isRetweet:(BOOL)yes
{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(TextPart *part1, TextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    NSMutableArray *specials = [NSMutableArray array];
    // 按顺序拼接每一段文字
    for (TextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *name = [EmotionTool emotionWithDesc:part.text].png;
            if (name) { // 能找到对应的图片
                //NSLog(@"%@",name);
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, WeicoRichTextFont.lineHeight, WeicoRichTextFont.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else if (part.special) { // 非表情的特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{       NSForegroundColorAttributeName: WeicoHighTextColor}];
            // 创建特殊对象
            
            Special *special = [[Special alloc] init];
            special.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            special.range = NSMakeRange(loc, len);
            [specials addObject:special];
            
        } else { // 非特殊文字
            UIColor *NormalColor = HJWColor(100, 100, 100);
            if (!yes) NormalColor = WEICO_CONTENT_COLOR;
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{       NSForegroundColorAttributeName: NormalColor}];
        }
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:WeicoRichTextFont range:NSMakeRange(0, attributedText.length)];
    //设置正文段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = LINE_SPACING;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    return attributedText;
}

@end
