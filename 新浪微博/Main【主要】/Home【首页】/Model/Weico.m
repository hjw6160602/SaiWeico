//
//  Weico.m
//  新浪微博
//
//  Created by shoule on 15/6/30.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "Weico.h"
#import "Photo.h"
#import "NSDate+Extension.h"
#import "RegexKitLite.h"
#import "RegExResult.h"
#import "EmotionTool.h"
#import "EmotionAttachment.h"
#import "Const.h"
#import <CoreText/CoreText.h>

@implementation Weico

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [Photo class]};
}

/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */
- (NSString *)show_time
{
    // _created_at == Thu Oct 16 17:06:25 +0800 2014
    // dateFormat == EEE MMM dd HH:mm:ss Z yyyy
    // NSString --> NSDate
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];

//    if (!createDate) {
//        return _created_at;
//    }
    
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
    
    return _created_at;
}

// source == <a href="http://app.weibo.com/t/feed/2llosp" rel="nofollow">OPPO_N1mini</a>
- (void)setSource:(NSString *)source
{
    // 正则表达式 NSRegularExpression
    // 截串 NSString

    if ([source isEqualToString:@""] || [source hasPrefix:@"来自"]) {
        _source = source;
    }
    else{
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</"].location - range.location;
        
        //    range.length = [source rangeOfString:@"<" options:NSBackwardsSearch];
        _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    }
    
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSString *reposts_count = [NSString stringWithFormat:@"%d",self.reposts_count];
    NSString *comments_count = [NSString stringWithFormat:@"%d",self.comments_count];
    NSString *attitudes_count = [NSString stringWithFormat:@"%d",self.attitudes_count];
    
    [encoder encodeObject:self.idstr forKey:@"idstr"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeObject:self.created_at forKey:@"created_at"];
    [encoder encodeObject:self.source forKey:@"source"];
    [encoder encodeObject:self.pic_urls forKey:@"pic_urls"];
    [encoder encodeObject:self.retweeted_status forKey:@"retweeted_status"];
    [encoder encodeObject:reposts_count forKey:@"reposts_count"];
    [encoder encodeObject:comments_count forKey:@"comments_count"];
    [encoder encodeObject:attitudes_count forKey:@"attitudes_count"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.idstr = [decoder decodeObjectForKey:@"idstr"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.user = [decoder decodeObjectForKey:@"user"];
        _created_at = [decoder decodeObjectForKey:@"created_at"];
        
        self.source = [decoder decodeObjectForKey:@"source"];
        self.pic_urls = [decoder decodeObjectForKey:@"pic_urls"];
        self.retweeted_status = [decoder decodeObjectForKey:@"retweeted_status"];
        self.reposts_count = [[decoder decodeObjectForKey:@"reposts_count"]intValue];
        self.comments_count = [[decoder decodeObjectForKey:@"comments_count"]intValue];
        self.attitudes_count = [[decoder decodeObjectForKey:@"attitudes_count"]intValue];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];

    // 链接、@提到、#话题#
    
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(RegExResult *result, NSUInteger idx, BOOL *stop) {
        
        if (result.isEmotion) { // 表情
            // 创建附件对象
            EmotionAttachment *attach = [[EmotionAttachment alloc] init];
            
            // 传递表情
            attach.emotion = [EmotionTool emotionWithDesc:result.string];
            attach.bounds = CGRectMake(0, -3, WeicoOrginalTextFont.lineHeight, WeicoOrginalTextFont.lineHeight);
            
            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedText appendAttributedString:attachString];
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [result.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:WeicoHighTextColor range:*capturedRanges];
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-]+ ?";
            [result.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:WeicoHighTextColor range:*capturedRanges];
                
            }];
            
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:WeicoHighTextColor range:*capturedRanges];
            }];
           
            [attributedText appendAttributedString:substr];
        }
    }];
    
    // 设置字体 value必须是一个CTFontRef
    [attributedText addAttribute:NSFontAttributeName value:WeicoRichTextFont range:NSMakeRange(0, attributedText.length)];
    // 设置正文段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = LINE_SPACING;
    //style.headIndent = HEAD_INDENT;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
    
    self.attributedText = attributedText;
}

/**
 *  根据字符串计算出所有的匹配结果（已经排好序）
 *
 *  @param text 字符串内容
 */
- (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        RegExResult *rr = [[RegExResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];
    
    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        RegExResult *rr = [[RegExResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(RegExResult *regExResult1, RegExResult *regExResult2) {
        NSUInteger location1 = regExResult1.range.location;
        NSUInteger location2 = regExResult2.range.location;
        return [@(location1) compare:@(location2)];
    }];
    return regexResults;
}


@end
