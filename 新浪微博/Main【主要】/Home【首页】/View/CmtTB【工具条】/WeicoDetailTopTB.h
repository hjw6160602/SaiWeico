//
//  WeicoDetailTopTB.h
//  新浪微博
//
//  Created by shoule on 15/7/22.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WeicoDetailTopTBButtonTypeRetweeted,
    WeicoDetailTopTBButtonTypeComment,
} WeicoDetailTBBtnType;

@class WeicoDetailTopTB, Weico;

@protocol  WeicoDetailTopTBDelegate <NSObject>
@optional
- (void)topTB:(WeicoDetailTopTB *)topTB didSelectedButton:(WeicoDetailTBBtnType)buttonType;
@end


@interface WeicoDetailTopTB : UIView
@property (nonatomic, weak) id<WeicoDetailTopTBDelegate> delegate;
@property (nonatomic, assign) Weico *weico;
+ (instancetype)toolbar;
@end
