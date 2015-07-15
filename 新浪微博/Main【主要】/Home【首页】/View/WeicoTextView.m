//
//  WeicoTextView.m
//  新浪微博
//
//  Created by shoule on 15/7/15.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoTextView.h"
#import "Special.h"
#import "Const.h"

#define WeicoTextViewCoverTag 2009

@implementation WeicoTextView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.scrollEnabled = NO;
        self.editable = NO;
        self.specialsArray = [NSArray array];
    }
    return self;
}

/**
 *  初始化特殊字符数组 只算一次
 *  算出特殊字符串在整个TextView中所占的矩形框大小
 */
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (frame.size.height==0 || frame.size.height==0) return;
    self.specialsArray = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    NSMutableArray *tempSpecials = [[NSMutableArray alloc]initWithCapacity:self.specialsArray.count];
    for (Special *special in self.specialsArray) {
        self.selectedRange = special.range;
        // self.selectedRange --影响--> self.selectedTextRange
        // 获得选中范围的矩形框
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        // 清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        NSMutableArray *tempRects= [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in rects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            [tempRects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.CGRects = [tempRects mutableCopy];
        [tempSpecials addObject:special];
    }
    self.specialsArray = tempSpecials;
}

/**
 *  @param 给我传入一个CGpoint
 *  @return 返回一个Special对象
 */
- (Special *)specialWhenTouchingWithGGPoint:(CGPoint)point{
    for (Special *special in self.specialsArray) {
        for (NSValue *rectValue in special.CGRects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) { // 点中了某个特殊字符串
                return special;
                break;
            }
        }
    }
    return nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 触摸对象 的 触摸点
    CGPoint point = [[touches anyObject] locationInView:self];
    Special *special = [self specialWhenTouchingWithGGPoint:point];
    for (NSValue *rectValue in special.CGRects) {
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = WeicoHighBGColor;
        cover.frame = rectValue.CGRectValue;
        cover.tag = WeicoTextViewCoverTag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //单击的时候设置为0.25秒之后再消除背景cover
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 当点击时间被打断的时候，就去掉特殊字符串后面的高亮背景
    for (UIView *child in self.subviews) {
        if (child.tag == WeicoTextViewCoverTag) [child removeFromSuperview];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    Special *special = [self specialWhenTouchingWithGGPoint:point];
    if (special) {
        return YES;
    }
    return NO;
}

@end
