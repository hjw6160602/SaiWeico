//
//  WeicoDetailController.m
//  新浪微博
//
//  Created by shoule on 15/7/14.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoDetailController.h"
#import "WeicoCell.h"
#import "WeicoFrame.h"

@interface WeicoDetailController ()

@end

@implementation WeicoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博正文";
    
    
//    // 创建微博详情控件
//    WeicoDetailView *detailView = [[WeicoDetailView alloc] init];
//    // 创建frame对象
//    WeicoDetailFrame *detailFrame = [[WeicoDetailFrame alloc] init];
//    detailFrame.status = self.weico;
//    // 传递frame数据
//    detailView.detailFrame = detailFrame;
//    // 设置微博详情的高度
//    detailView.height = detailFrame.frame.size.height;
//    self.tableView.tableHeaderView = detailView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
