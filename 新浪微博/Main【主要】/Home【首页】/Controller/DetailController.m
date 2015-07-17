//
//  DetailController.m
//  新浪微博
//
//  Created by shoule on 15/7/16.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "DetailController.h"
#import "WeicoDetailView.h"
#import "WeicoDetailFrame.h"
#import "UIView+Extension.h"
#import "Const.h"

@interface DetailController ()

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博正文";
    
    // 创建微博详情控件
    WeicoDetailView *detailView = [[WeicoDetailView alloc] init];
    // 创建frame对象
    WeicoDetailFrame *detailFrame = [[WeicoDetailFrame alloc] init];
    detailFrame.weico = self.weico;
    // 传递frame数据
    detailView.detailFrame = detailFrame;
    // 设置微博详情的高度
    //detailView.height = detailFrame.frame.size.height;
    detailView.height = 300;
    self.tableView.tableHeaderView = detailView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *topBar = [[[NSBundle mainBundle]loadNibNamed:@"CmtTopBar" owner:self options:nil]firstObject];
//    topBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//    topBar.backgroundColor = WeicoHighBGColor;
    return topBar;
    
}
@end
