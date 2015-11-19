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
#import "webLinkController.h"
#import "SingleData.h"

#define WeicoTextViewCoverTag 2009

@implementation WeicoTextView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.scrollEnabled = NO;
        self.editable = NO;
    }
    return self;
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    self.specialsArray = [NSArray array];
    self.specialsArray = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.specialsArray.count == 0) return NO;
    
    BOOL mustInitSpecialArrayRect = YES;
    for (Special *special in self.specialsArray) {
        for (NSValue *rectValue in special.CGRects) {
            if (rectValue) { // 点中了某个特殊字符串
                mustInitSpecialArrayRect = NO;
                break;
            }
        }
        break;
    }
    if (mustInitSpecialArrayRect) {
        [self initSpecialArrayRect];
    }
    self.special = [self TouchingWithGGPoint:point];
    if (self.special) {
        return YES;
    }
    return NO;
}

/**
 *  初始化特殊字符数组
 *  算出特殊字符串在整个TextView中所占的矩形框大小
 *  神奇的事：NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
 *  只可以在TextView监听到点击事件的时候，才会返回正确地Rect结果，
 *  否则返回结果为：{inf,inf},{0,0}
 */
- (void)initSpecialArrayRect{
    NSMutableArray *tempSpecials = [[NSMutableArray alloc]initWithCapacity:self.specialsArray.count];
    for (Special *special in self.specialsArray) {
        self.selectedRange = special.range;
        // self.selectedRange --影响--> self.selectedTextRange
        // 获得选中范围的矩形框
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        // 清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        NSMutableArray *tempRect = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) {
                //NSLog(@"Error:%@",NSStringFromCGRect(rect));
                continue;
            }
            [tempRect addObject:[NSValue valueWithCGRect:rect]];
        }
        if (tempRect.count == 0) {
            HJWLog(@"Error:没有得到 %@ %@的矩形框！",special.text,NSStringFromRange(special.range));
            continue;
        }
        special.CGRects = [tempRect mutableCopy];
        [tempSpecials addObject:special];
        
    }
    self.specialsArray = tempSpecials;
}

/**
 *  @param 给我传入一个CGpoint
 *  @return 返回一个Special对象
 */
- (Special *)TouchingWithGGPoint:(CGPoint)point{
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
    for (NSValue *rectValue in self.special.CGRects) {
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

//extern HomeController *G_HomeController;

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 当点击时间被打断的时候，就去掉特殊字符串后面的高亮背景
    for (UIView *child in self.subviews) {
        if (child.tag == WeicoTextViewCoverTag) [child removeFromSuperview];
    }
    NSLog(@"跳到百度页面");
    [SINGLE.homeController.navigationController pushViewController:[webLinkController new] animated:YES];
}

@end
