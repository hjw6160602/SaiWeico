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
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
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


@end
