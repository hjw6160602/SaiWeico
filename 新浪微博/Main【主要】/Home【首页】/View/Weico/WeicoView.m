//
//  WeicoView.m
//  新浪微博
//
//  Created by shoule on 15/7/17.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoView.h"
#import "WeicoDetailView.h"

@interface WeicoView ()
@property (nonatomic, strong) WeicoDetailView *detailView;
@end

@implementation WeicoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { // 初始化子控件
        self.userInteractionEnabled = YES;
        
        // 2.添加Detail微博
        WeicoDetailView *detailView = [[WeicoDetailView alloc] init];
        [self addSubview:detailView];
        self.detailView = detailView;
        
    }
    return self;
}

/*  WeicoFrame的set方法  */
- (void)setWeicoFrame:(WeicoFrame *)weicoFrame
{
    _weicoFrame = weicoFrame;
    // 1.微博具体内容的frame数据
//    self.detailView.detailFrame = weicoFrame.detailF;
//    
//    // 2.底部工具条的frame数据
//    self.toolbar.frame = weicoFrame.toolbarF;
//    self.toolbar.weico = weicoFrame.weico;
}

@end
