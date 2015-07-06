//
//  WeicoController.m
//  新浪微博
//
//  Created by shoule on 15/7/1.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoController.h"
#import "TabBarItem.h"

@interface WeicoController ()

@end

@implementation WeicoController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"tabbar_compose_button"];
    UIImage *selectedImage = [UIImage imageNamed:@"tabbar_compose_button_highlighted"];
    TabBarItem *tabBarItem = [[TabBarItem alloc]initWithTitle:nil image:image selectedImage:selectedImage];
    self.tabBarItem = tabBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
