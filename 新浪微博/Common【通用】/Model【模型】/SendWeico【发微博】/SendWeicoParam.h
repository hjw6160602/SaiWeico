//
//  SendWeicoParam.h
//  新浪微博
//
//  Created by shoule on 15/8/5.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParam.h"

@interface SendWeicoParam : BaseParam
/**	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
@property (nonatomic, copy) NSString *status;
@end