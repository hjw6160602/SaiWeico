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
#import "DetailController.h"
#import "API.h"

@interface HomeController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  微博数组（里面放的都是微博字典，一个字典对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *weicoFrames;
@end



@implementation HomeController

- (NSMutableArray *)weicoFrames
{
    if (!_weicoFrames) {
        self.weicoFrames = [NSMutableArray array];
    }
    return _weicoFrames;
}

#pragma mark - ViewControllers

HomeController *G_HomeController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    // 获得用户信息（昵称）
    [self initUserInfo];
    [self initLastWeicos];
    [self initControls];
    G_HomeController = self;
    //获得未读数
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(initUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Init
- (void)initNavi{
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
- (void)initUserInfo{
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
    [mgr GET:GET_USERINFO parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        [responseObject writeToFile:@"tempWeico.plist" atomically:YES];
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

- (void)initLastWeicos{//UnArchiveFrom.archive
    NSArray *weicoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:FILE_NAME];
    NSArray *weicoFramesArray = [self weicoFramesWithWeicos:weicoArray];
    self.weicoFrames = [[NSMutableArray alloc]initWithArray:weicoFramesArray];
    __weak typeof(self) weakSelf = self;
    if (self.weicoFrames.count != 0) {
        [self.tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadMoreWeico];
        }];
    }
    if (self.weicoFrames.count == 0) [self loadNewWeico];
}

/** 这里的loadNewWeico方法与initControls方法的先后顺序很重要
  * 因为在添加下拉刷新控件时，为了防止self在block中的循环引用，所以使用了self的弱引用来作为下拉刷新的对象
  * 然而如果 读取新微博方法 写在添加下拉刷新方法的后面
  * 导致循环加载
 */
- (void)initControls{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNewWeico];
    }];
}

- (void)initUnreadCount
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    
    [mgr GET:GET_REMIND_UNREAD parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 微博的未读数
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            // 设置提醒数字
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HJWLog(@"请求失败-%@", error);
    }];
}

- (void)loadNewWeico{
    [self.tableView.header beginRefreshing];
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //params[@"count"] = @20;
    
    // 取出最前面的微博（最新的微博，ID最大的微博）
    WeicoFrame *firstWeicoF = [self.weicoFrames firstObject];
    if (firstWeicoF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstWeicoF.weico.idstr;
        
    }

    // 3.发送请求
    [mgr GET:GET_FRIENDS_TIMELINE_WEICO parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        // 取得"微博字典"数组
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newWeico = [Weico objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        if (newWeico.count != 0) {
            // 将 Weico数组 转为 weicoFrame数组
            NSArray *newFrames = [self weicoFramesWithWeicos:newWeico];
            
            // 将最新的微博数据，添加到总数组的最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.weicoFrames insertObjects:newFrames atIndexes:set];
            
            [self ArchiveToFile];
        }
        // 显示最新微博的数量
        [self showNewWeicoCount:newWeico.count];
        // 将最新的微博数据，添加到总数组的最前面
        [self.tableView.header endRefreshing];
        // 刷新表格
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
    [mgr GET:GET_FRIENDS_TIMELINE_WEICO parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newWeico = [Weico objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSArray *newFrames = [self weicoFramesWithWeicos:newWeico];
        // 将更多的微博数据，添加到总数组的最后面
        [self.weicoFrames addObjectsFromArray:newFrames];
        // 刷新表格
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HJWLog(@"请求失败-%@", error);
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - TableView Data Source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"微博总数：%d",(int)self.weicoFrames.count);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailController *detailVC = [[DetailController alloc]init];
//    WeicoFrame *frame = self.weicoFrames[indexPath.row];
//    detailVC.weico = frame.weico;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Actions
/**
 *  将Weico模型转为WeicoFrame模型
 */
- (NSArray *)weicoFramesWithWeicos:(NSArray *)weicoArray{
    NSMutableArray *frames = [NSMutableArray array];
    for (Weico *weico in weicoArray) {
        WeicoFrame *f = [[WeicoFrame alloc] init];
        f.weico = weico;
        [frames addObject:f];
    }
    return frames;
}

- (void)ArchiveToFile{
    NSInteger maxIndex = 25;
    NSMutableArray *weicoArray = [NSMutableArray array];
    if (self.weicoFrames.count < 25) maxIndex = 20;
    
    for (int i=0; i<maxIndex; i++) {
        WeicoFrame* temp_WeicoFrame = self.weicoFrames[i];
        Weico *temp_Weico = temp_WeicoFrame.weico;
        [weicoArray addObject:temp_Weico];
    }
    [NSKeyedArchiver archiveRootObject:weicoArray toFile:FILE_NAME];
}

/**
 *  显示最新微博的数量
 *  @param count 最新微博的数量
 */
- (void)showNewWeicoCount:(NSUInteger)count
{
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"已是最新的微博啦~";
    } else {
        label.text = [NSString stringWithFormat:@"%zd 条新微博", count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}
#pragma mark - Target Selector
- (void)searchFriend{}
- (void)POP{ }
- (void)titleClick:(UIButton*)sender {}
@end
