//
//  SingleData.h
//  新浪微博
//
//  Created by shoule on 15/11/19.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"


@interface SingleData : NSObject
singleton_interface(SingleData)

@property (nonatomic, strong) UIViewController *homeController;

@end
