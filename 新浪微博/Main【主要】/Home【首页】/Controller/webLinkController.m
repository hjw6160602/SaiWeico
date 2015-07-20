//
//  webLinkController.m
//  新浪微博
//
//  Created by shoule on 15/7/15.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "webLinkController.h"

@interface webLinkController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation webLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百度";
    NSURL *URL = [[NSURL alloc]initWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:URL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
