//
//  WeicoPhotosView.m
//  新浪微博
//
//  Created by shoule on 15/7/2.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "WeicoPhotosView.h"
#import "WeicoPhotoView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define WeicoPhotoWH 70
#define WeicoPhotoMargin 10
#define WeicoPhotoMaxCol(count) ((count==4)?2:3)


@implementation WeicoPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photosCount = (int)photos.count;
    
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        WeicoPhotoView *photoView = [[WeicoPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        WeicoPhotoView *photoView = self.subviews[i];
        photoView.tag = i;
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            // 添加手势监听器（一个手势监听器 只能 监听对应的一个view）
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    int photosCount = (int)self.photos.count;
    int maxCol = WeicoPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        WeicoPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (WeicoPhotoWH + WeicoPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (WeicoPhotoWH + WeicoPhotoMargin);
        photoView.width = WeicoPhotoWH;
        photoView.height = WeicoPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(int)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = WeicoPhotoMaxCol(count);
    
    // 列数
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * WeicoPhotoWH + (cols - 1) * WeicoPhotoMargin;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * WeicoPhotoWH + (rows - 1) * WeicoPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    NSUInteger count = self.photos.count;
    for (int i = 0; i<count; i++) {
        Photo *pic = self.photos[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置图片的路径
        photo.url = [NSURL URLWithString: pic.bmiddle_pic];
        // 设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    // 3.显示浏览器
    [browser show];
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
}

@end
