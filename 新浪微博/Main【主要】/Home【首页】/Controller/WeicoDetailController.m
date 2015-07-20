//
//  WeicoDetailController.m
//  新浪微博
//
//  Created by shoule on 15/7/20.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoDetailController.h"
#import "WeicoDetailView.h"
#import "WeicoFrame.h"
#import "Weico.h"
#import "UIView+Extension.h"
#import "Const.h"
@interface WeicoDetailController ()
@property (nonatomic, strong) UIView *bottomTB;
@end

@implementation WeicoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControls];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.bottomTB.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bottomTB.hidden = NO;
}

- (void)initControls{
    self.title = @"微博正文";
    self.tableView.backgroundColor = GLOBE_BG;
    //self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 64);
    self.tableView.rowHeight = 60.0f;
    // 创建微博详情控件
    WeicoDetailView *detailView = [[WeicoDetailView alloc] init];
    // 创建frame对象
    detailView.weicoFrame = self.weicoFrame;
    
    // 设置微博详情的高度
    if (self.weicoFrame.weico.retweeted_status) {
        CGFloat detailViewH = self.weicoFrame.cellHeight - 10;
        detailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, detailViewH);
    }
    else{
        detailView.frame = self.weicoFrame.originalViewF;
    }
    self.tableView.tableHeaderView = detailView;
    self.bottomTB = [[[NSBundle mainBundle]loadNibNamed:@"ContentTB" owner:self options:nil]firstObject];
    self.bottomTB.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bottomTB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

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

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
