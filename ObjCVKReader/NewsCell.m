//
//  NewsCell.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import "NewsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) prepareForReuse{
    [super prepareForReuse];
    [self.feedImageView sd_cancelCurrentAnimationImagesLoad];
    self.feedImageViewHeightConstraint.constant = 0;
}

@end
