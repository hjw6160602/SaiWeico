//
//  CommentCell.m
//  新浪微博
//
//  Created by shoule on 15/8/6.
//  Copyright © 2015年 SaiDicaprio. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "IconView.h"

@interface CommentCell()

@property (weak, nonatomic) IBOutlet IconView *IconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;

@end

@implementation CommentCell

- (void)setComment:(Comment *)comment{
    _comment = comment;
    [self.IconImage sd_setImageWithURL:[NSURL URLWithString:self.comment.user.profile_image_url]
                      placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.nameLabel.text = self.comment.user.name;
    self.timeLabel.text = self.comment.show_time;
    self.TextLabel.text = self.comment.text;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
