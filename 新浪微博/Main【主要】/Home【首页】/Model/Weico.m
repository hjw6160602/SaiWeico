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
#import "EmotionTool.h"
#import "Emotion.h"
#import "Const.h"
#import "TextPart.h"
#import "Special.h"
#import <CoreText/CoreText.h>

@implementation Weico

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [Photo class]};
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

- (void)setText:(NSString *)text
{
    _text = [text copy];
    // 利用text生成attributedText
    self.attributedText = [self attributedTextWithText:text isRetweet:NO];
}

- (void)setRetweeted_status:(Weico *)retweeted_status
{
    if (!retweeted_status) return;
    _retweeted_status = retweeted_status;
    
    NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status.user.name, retweeted_status.text];
    self.retweetedAttributedText = [self attributedTextWithText:retweetContent isRetweet:YES];
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
        _source = @"来自新浪微博";
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


@end