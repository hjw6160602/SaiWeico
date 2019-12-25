//
//  IconView.m
//  新浪微博
//
//  Created by shoule on 15/7/6.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import "IconView.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

@interface IconView()
@property (nonatomic, weak) UIImageView *iconImg;
@property (nonatomic, weak) UIImageView *verifiedView;
@end

@implementation IconView

- (UIImageView *)verifiedView{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (UIImageView *)iconImg{
    if (!_iconImg) {
        UIImageView *iconImg = [[UIImageView alloc] init];
        [self addSubview:iconImg];
        self.iconImg = iconImg;
    }
    return _iconImg;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setUser:(User *)user
{
    _user = user;
    
    // 1.下载图片
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url]
                    placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];

    // 2.设置加V图片
    switch (user.verified_type) {
        case UserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case UserVerifiedOrgEnterprice:
        case UserVerifiedOrgMedia:
        case UserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case UserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconImg.frame = self.bounds;
    self.iconImg.layer.cornerRadius = self.iconImg.width/2;
    self.iconImg.layer.masksToBounds = YES;
//    self.iconImg.layer.borderWidth = 2.0f;
//    self.iconImg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.8;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
    self.verifiedView.layer.cornerRadius = self.verifiedView.width/2;
    self.iconImg.layer.masksToBounds = YES;
    self.verifiedView.layer.borderWidth = 1.5f;
    self.verifiedView.layer.borderColor = [UIColor whiteColor].CGColor;
}
@end
