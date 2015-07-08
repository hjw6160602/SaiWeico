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

#define WeicoPhotoWH 70
#define WeicoPhotoMargin 10
#define WeicoPhotoMaxCol(count) ((count==4)?2:3)

@interface WeicoPhotosView()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGRect lastFrame;

@end

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

//- (void)setPic_urls:(NSArray *)pic_urls
//{
//    _pic_urls = pic_urls;
//    
//    for (int i = 0; i<HMStatusPhotosMaxCount; i++) {
//        HMStatusPhotoView *photoView = self.subviews[i];
//        
//        if (i < pic_urls.count) { // 显示图片
//            photoView.photo = pic_urls[i];
//            photoView.hidden = NO;
//        } else { // 隐藏
//            photoView.hidden = YES;
//        }
//    }
//}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    // 1.添加一个遮盖
    UIView *cover = [[UIView alloc] init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor blackColor];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    // 2.添加图片到遮盖上
    WeicoPhotoView *photoView = (WeicoPhotoView *)recognizer.view;
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:photoView.photo.thumbnail_pic] placeholderImage:photoView.image];
    //    imageView.image = photoView.image;
    // 将photoView.frame从self坐标系转为cover坐标系
    imageView.frame = [cover convertRect:photoView.frame fromView:self];
    self.lastFrame = imageView.frame;
    [cover addSubview:imageView];
    self.imageView = imageView;
    
    // 3.放大
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = cover.width; // 占据整个屏幕;
        
        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (cover.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.imageView.frame = self.lastFrame;
    } completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        self.imageView = nil;
    }];
}

@end
