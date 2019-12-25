//
//  EmotionKeybord.m
//  新浪微博
//
//  Created by shoule on 15/8/31.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import "EmotionKeybord.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
@interface EmotionKeybord()
@property (nonatomic, strong) EmotionListView *ListView;
@property (nonatomic, strong) EmotionTabBar *TabBar;
@end

@implementation EmotionKeybord

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.表情内容
        self.ListView = [[EmotionListView alloc]init];
        [self addSubview:self.ListView];
        // 2.TabBar
        self.TabBar = [[EmotionTabBar alloc]init];
        [self addSubview:self.TabBar];
    }
    return self;
}

- (void)layoutSubviews{
    
}

@end
