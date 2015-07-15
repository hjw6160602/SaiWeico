//
//  WeicoTextView.m
//  新浪微博
//
//  Created by shoule on 15/7/15.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoTextView.h"
#import "Special.h"

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 触摸对象
    UITouch *touch = [touches anyObject];
    
    // 触摸点
    CGPoint point = [touch locationInView:self];
    
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    BOOL contains = NO;
    
    for (Special *special in specials) {
        self.selectedRange = special.range;
        // self.selectedRange --影响--> self.selectedTextRange
        // 获得选中范围的矩形框
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        // 清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        
        for (UITextSelectionRect *selectionRect in rects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            if (CGRectContainsPoint(rect, point)) { // 点中了某个特殊字符串
                contains = YES;
                break;
            }
        }
        
        if (contains) {
            for (UITextSelectionRect *selectionRect in rects) {
                CGRect rect = selectionRect.rect;
                if (rect.size.width == 0 || rect.size.height == 0) continue;
                
                UIView *cover = [[UIView alloc] init];
                cover.backgroundColor = [UIColor greenColor];
                cover.frame = rect;
                cover.tag = WeicoTextViewCoverTag;
                cover.layer.cornerRadius = 5;
                [self insertSubview:cover atIndex:0];
            }
            
            break;
        }
    }
    // 在被触摸的特殊字符串后面显示一段高亮的背景
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

@end
