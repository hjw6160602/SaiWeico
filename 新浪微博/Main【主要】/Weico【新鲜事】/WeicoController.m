//
//  WeicoController.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoController.h"
#import "UIView+Extension.h"
#import "AccountTool.h"
#import "HJWExtension.h"

@interface WeicoController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;

@end

@implementation WeicoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initControls];
}

- (void)initNavi{
    self.rightBarButtonItem.enabled = NO;
    NSString *name = [AccountTool account].name;
    
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        NSRange prefixRange = [str rangeOfString:prefix];
        NSRange nameRange = [str rangeOfString:name];
        
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:prefixRange];
        [attrStr addAttribute:NSForegroundColorAttributeName value:HJWColor(49, 49, 49) range:prefixRange];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:nameRange];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:nameRange];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else {
        self.title = prefix;
    }
}

- (void)initControls{
   
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    NSLog(@"发送微博");
}

@end
