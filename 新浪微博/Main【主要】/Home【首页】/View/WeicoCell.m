//
//  WeicoCell.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//
#import "WeicoCell.h"
#import "WeicoFrame.h"
#import "WeicoToolBar.h"
#import "WeicoView.h"
@interface WeicoCell()
@property (strong,nonatomic) WeicoView *weicoView;
@end
@implementation WeicoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"weico";
    WeicoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WeicoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.添加微博具体内容
        WeicoView *weicoView = [[WeicoView alloc] init];
        [self.contentView addSubview:weicoView];
        self.weicoView = weicoView;
        
        // 3.cell的设置
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setWeicoFrame:(WeicoFrame *)weicoFrame{
    _weicoFrame = weicoFrame;
    
    // 1.微博具体内容的frame数据
    self.weicoView.weicoFrame = weicoFrame;
}

@end