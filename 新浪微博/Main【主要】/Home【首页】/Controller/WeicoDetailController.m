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
#import "WeicoDetailTopTB.h"
#import "CommentResult.h"
@import AFNetworking;
#import "CommentParam.h"
#import "WeicoTool.h"
#import "CommentCell.h"
#import "CommentFrame.h"
#import "Comment.h"
#import "Const.h"

@interface WeicoDetailController () <WeicoDetailTopTBDelegate>
@property (nonatomic, strong) UIView *bottomTB;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *commentFrames;
@property (nonatomic, strong) WeicoDetailTopTB *topTB;
@property (nonatomic, strong) Weico *weico;
@end

@implementation WeicoDetailController


- (NSMutableArray *)commentFrames
{
    if (_commentFrames == nil) {
        self.commentFrames = [NSMutableArray array];
    }
    return _commentFrames;
}

- (WeicoDetailTopTB *)topTB
{
    if (!_topTB) {
        self.topTB = [WeicoDetailTopTB toolbar];
        self.topTB.weico = self.weico;
        self.topTB.delegate = self;
    }
    return _topTB;
}

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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    self.weico = self.weicoFrame.weico;
    
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

#pragma mark - 顶部工具条的代理
- (void)topTB:(WeicoDetailTopTB *)topTB didSelectedButton:(WeicoDetailTBBtnType)buttonType
{
    switch (buttonType) {
        case WeicoDetailTopTBButtonTypeComment: // 评论
            [self getCmtRequest];
            break;
            
        case WeicoDetailTopTBButtonTypeRetweeted: // 转发
            //[self getCmtRetweeteds];
            break;
    }
}

- (void)getCmtRequest{
    CommentParam *param = [CommentParam param];
    param.id = self.weico.idstr;
    Comment *cmt = [self.comments firstObject];
    param.since_id = cmt.idstr;
    
    [WeicoTool commentsWithParam:param success:^(CommentResult *result) {
        // 评论总数
        self.weico.comments_count = result.total_number;
        self.topTB.weico= self.weico;
        NSArray *comments = result.comments;
        if (comments.count != 0) {
            // 将 comment数组 转为 commentFrame数组
            NSArray *commentFrames = [self commentFramesWithComments:comments];
            
            // 将最新的评论数据，添加到总数组的最前面
            NSRange range = NSMakeRange(0, comments.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.commentFrames insertObjects:commentFrames atIndexes:set];
            
        }
        // 累加评论数据
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.comments.count)];
//        [self.comments insertObjects:result.comments atIndexes:set];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getCmtRetweeteds{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentFrames.count;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentFrame *frame = self.commentFrames[indexPath.row];
    if (frame.cellHeight) {
        return frame.cellHeight;
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    CommentCell *cell = [CommentCell cellWithTableView:tableView];

    // 给cell传递模型数据
    cell.commentFrame = self.commentFrames[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.topTB;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.topTB.height;
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

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)commentFramesWithComments:(NSArray *)comments{
    NSMutableArray *frames = [NSMutableArray array];
    for (Comment *comment in comments) {
        CommentFrame *f = [[CommentFrame alloc] init];
        f.comment = comment;
        [frames addObject:f];
    }
    return frames;
}

@end
