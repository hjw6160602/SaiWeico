//
//  HomeController.m
//  新浪微博
//
//  Created by shoule on 15/6/26.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "HomeController.h"
#import "AccountTool.h"
#import "AFNetworking.h"
#import "HJWExtension.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "HJWTitleButton.h"
#import "UIImageView+WebCache.h"
#import "Weico.h"
#import "User.h"
#import "WeicoFrame.h"
#import "WeicoCell.h"
#import "MJRefresh.h"

@interface HomeController ()<UITableViewDataSource,UITableViewDelegate>
{
    //NSInteger index;
}
/**
 *  微博数组（里面放的都是微博字典，一个字典对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *weicoFrames;
@end

@implementation HomeController

#pragma mark - 懒加载WeicoFrame数组
- (NSMutableArray *)weicoFrames
{
    if (!_weicoFrames) {
        self.weicoFrames = [NSMutableArray array];
    }
    return _weicoFrames;
}

#pragma mark - ViewControllers
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    // 获得用户信息（昵称）
    [self initUserInfo];
    [self initControls];
    // 读取所有关注的微博
    [self loadNewWeico];
}

#pragma mark - Init
- (void)initNavi
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchFriend) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(POP) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    HJWTitleButton *titleButton = [[HJWTitleButton alloc] init];
    // 设置图片和文字
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

/**
 *  获得用户信息（昵称）
 */
- (void)initUserInfo
{
    // https://api.weibo.com/2/users/show.json
    // access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    // uid	false	int64	需要查询的用户ID。
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        User *user = [User objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        
        [AccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HJWLog(@"请求失败-%@", error);
    }];
}

- (void)initControls{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNewWeico];
    }];
    // 加载更多的微博数据
    //__weak typeof(self) weakSelf = self;
}

- (void)loadNewWeico{
    [self.tableView.header beginRefreshing];
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //    params[@"count"] = @10;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 取得"微博字典"数组
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newWeico = [Weico objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将 Weico数组 转为 weicoFrame数组
        NSArray *newFrames = [self weicoFramesWithWeicos:newWeico];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.weicoFrames insertObjects:newFrames atIndexes:set];
        
        //[self.weicoFrames addObjectsFromArray:newFrames];
        // 将最新的微博数据，添加到总数组的最前面
        [self.tableView.header endRefreshing];
        // 刷新表格
        __weak typeof(self) weakSelf = self;
        if (self.weicoFrames.count != 0) {
            [self.tableView addLegendFooterWithRefreshingBlock:^{
                [weakSelf loadMoreWeico];
            }];
        }

        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HJWLog(@"请求失败-%@", error);
        [self.tableView.header endRefreshing];
    }];
}
/**
 *  加载更多的微博数据
 */
- (void)loadMoreWeico
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    WeicoFrame *lastWeicoFrame = [self.weicoFrames lastObject];
    if (lastWeicoFrame) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastWeicoFrame.weico.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newWeico = [Weico objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.weicoFrames addObjectsFromArray:newWeico];
        
        // 刷新表格
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HJWLog(@"请求失败-%@", error);
        [self.tableView.footer endRefreshing];
    }];
}



/**
 *  将Weico模型转为WeicoFrame模型
 */
- (NSArray *)weicoFramesWithWeicos:(NSArray *)weicoArray
{
    NSMutableArray *frames = [NSMutableArray array];
    for (Weico *weico in weicoArray) {
        WeicoFrame *f = [[WeicoFrame alloc] init];
        f.weico = weico;
        [frames addObject:f];
    }
    return frames;
}

#pragma mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.weicoFrames.count);
    return self.weicoFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    WeicoCell *cell = [WeicoCell cellWithTableView:tableView];

    // 给cell传递模型数据
    cell.weicoFrame = self.weicoFrames[indexPath.row];
    return cell;
}
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeicoFrame *frame = self.weicoFrames[indexPath.row];
    //NSLog(@"%d",index);
    if (frame.cellHeight) {
        return frame.cellHeight;
    }
    else return 0;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //    scrollView == self.tableView == self.view
//    // 如果tableView还没有数据，就直接返回
//    if (self.weicoFrames.count == 0) return;
//    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    
////    NSLog(@"scrollView.contentSize.height:%f",scrollView.contentSize.height);
////    NSLog(@"scrollView.contentInset.bottom:%f",scrollView.contentInset.bottom);
////    NSLog(@"scrollView.height:%f",scrollView.height);
////    NSLog(@"self.tableView.tableFooterView.height:%f",self.tableView.tableFooterView.height);
//    
//    // 当最后一个cell完全显示在眼前时，contentOffset的y值
//    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
//        
//        
//    }
//    
//    /*
//     contentInset：除具体内容以外的边框尺寸
//     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
//     contentOffset:
//     1.它可以用来判断scrollView滚动到什么位置
//     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
//     */
//}

#pragma mark - Target Selector
- (void)searchFriend{}
- (void)POP{ }
- (void)titleClick:(UIButton*)sender {}
@end
