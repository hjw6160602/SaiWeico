//
//  OAuthViewController.m
//  新浪微博
//
//  Created by shoule on 15/6/25.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "OAuthViewController.h"
//#import "MBProgressHUD+HJW.h"
@import AFNetworking;
@import MJExtension;
#import "Account.h"
#import "AccountTool.h"
#import "UIWindow+Extension.h"
#import "Const.h"
#import "API.h"


@interface OAuthViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"正在加载..."];
    // 2.用webView加载登录页面（新浪提供的）
    // 请求地址：https://api.weibo.com/oauth2/authorize
    /* 请求参数：
     client_id	true	string	申请应用时分配的AppKey。
     redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
     */
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1566588143&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}

#pragma mark - webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得url
    NSString *url = request.URL.absoluteString;
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { // 是回调地址
        // 截取code=后面的参数值
        NSUInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

/*
 *  利用code（授权成功后的request token）换取一个accessToken
 *  @param code 授权成功后的request token
 */
- (void)accessTokenWithCode:(NSString *)code
{
    /*

     * 请求参数：
     * client_id：申请应用时分配的AppKey
     * client_secret：申请应用时分配的AppSecret
     * grant_type：使用authorization_code
     * redirect_uri：授权成功后的回调地址
     * code：授权成功后返回的code
     */
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = AppKey;
    params[@"client_secret"] = AppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.baidu.com";
    params[@"code"] = code;
    
    // 3.发送请求
    [mgr POST:POST_ACCESS_TOKEN parameters:params
      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
          [MBProgressHUD hideHUD];
          // 将返回的账号字典数据 --> 模型，存进沙盒
          Account *account= [Account accountWithDict:responseObject];
          
          // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
          [AccountTool saveAccount:account];
          // 切换窗口的根控制器
          UIWindow *window = [UIApplication sharedApplication].keyWindow;
          [window switchRootViewController];
          
          
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HJWLog(@"请求失败-%@", error);
        [MBProgressHUD hideHUD];
    }];
}

@end
