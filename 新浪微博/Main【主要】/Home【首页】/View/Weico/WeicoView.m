//
//  WeicoView.m
//  新浪微博
//
//  Created by shoule on 15/7/17.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoView.h"
#import "WeicoFrame.h"
#import "WeicoDetailView.h"
#import "WeicoToolBar.h"

@interface WeicoView ()
@property (nonatomic, strong) WeicoDetailView *detailView;
@property (nonatomic, strong) WeicoToolBar *toolBar;
@end

@implementation WeicoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        // 2.添加Detail微博
        WeicoDetailView *detailView = [[WeicoDetailView alloc] init];
        [self addSubview:detailView];
        self.detailView = detailView;
        
        WeicoToolBar *toolBar = [[WeicoToolBar alloc]init];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
    }
    return self;
}

/*  WeicoFrame的set方法  */
- (void)setWeicoFrame:(WeicoFrame *)weicoFrame
{
    _weicoFrame = weicoFrame;
    self.frame = _weicoFrame.frame;
    
     //1.微博具体内容的frame数据
    self.detailView.detailFrame = weicoFrame.detailF;
    // 2.底部工具条的frame数据

    self.toolBar.weico = weicoFrame.weico;
    self.toolBar.frame = weicoFrame.toolbarF;
}

@end
