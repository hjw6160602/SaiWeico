//
//  HomeController.h
//  新浪微博
//
//  Created by shoule on 15/6/26.
//  Copyright (c) 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DOC_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]
#define FILE_NAME  [DOC_PATH stringByAppendingPathComponent:@"tempWeico.archive"]

@interface HomeController : UITableViewController

@end
