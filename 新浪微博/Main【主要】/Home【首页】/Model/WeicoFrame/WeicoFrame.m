//
//  WeicoFrame.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoFrame.h"
#import "Weico.h"
#import "WeicoPhotosView.h"
#import "Const.h"
#import "WeicoDetailFrame.h"
#import <UIKit/UIKit.h>

@implementation WeicoFrame

- (void)setWeico:(Weico *)weico
{
    _weico = weico;
    
    // 1.计算微博具体内容（微博整体）
    [self setupDetailFrame];
    
    // 2.计算底部工具条
    [self setupToolbarFrame];
    
    // 3.计算cell的高度
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight);
}

/**
 *  计算微博具体内容（微博整体）
 */
- (void)setupDetailFrame
{
    WeicoDetailFrame *detailFrame = [[WeicoDetailFrame alloc] init];
    detailFrame.weico= self.weico;
    self.detailF = detailFrame;
}

/**
 *  计算底部工具条
 */
- (void)setupToolbarFrame
{
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.detailF.frame);
    CGFloat toolbarW = SCREEN_WIDTH;
    CGFloat toolbarH = 35;
    
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
}


@end
