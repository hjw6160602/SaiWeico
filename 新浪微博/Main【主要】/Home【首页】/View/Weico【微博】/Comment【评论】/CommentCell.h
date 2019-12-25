//
//  CommentCell.h
//  新浪微博
//
//  Created by shoule on 15/8/6.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrame.h"
#import "Comment.h"

@interface CommentCell : UITableViewCell

//@property (nonatomic, strong) Comment *comment;
@property (nonatomic, strong) CommentFrame *commentFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
