//
//  HeadView.m
//  新浪微博
//
//  Created by shoule on 15/7/9.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "HeadView.h"
#import "UIView+Extension.h"
#import "Const.h"


@interface HeadView ()

@end

@implementation HeadView

- (void)layoutSubviews{
    
    //添加图片到scrollView中
    CGFloat scrollW = self.width;
    CGFloat scrollH = self.height;
    self.contentSize = CGSizeMake(4* scrollW, 0);
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"DiscoverHeader%d.png", i];
        UIImage *image = [UIImage imageNamed:name];
        
        imageView.image = image;
        
        [self addSubview:imageView];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    double page = self.contentOffset.x / self.width;
//    //计算出页码
//    self.pageControl.currentPage = (int)(page + 0.5);
//}

@end
