//
//  NewsCellModel.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import "NewsCellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <VKSdk.h>

@interface NewsCellModel()
@property Newsfeed *feed;
@property (weak,nonatomic) NewsCell* cell;
@end

@implementation NewsCellModel
- (instancetype)initWithEntity:(Newsfeed*) feed
{
    self = [super init];
    if (self) {
        self.feed = feed;
    }
    return self;
}

- (Newsfeed *)getFeed {
    return self.feed;
}

- (void) fillCell:(NewsCell *)cell{
    self.cell = cell;
    cell.feedTextLabel.text = self.feed.text;
    cell.authorName.text = self.feed.source_name;
    NSString *likesString = [NSString stringWithFormat:@"%ld", (long)self.feed.likes_count];
    if (self.feed.likes_count > 1000) {
        double likeCount = (double)self.feed.likes_count/1000;
        likesString = [NSString stringWithFormat:@"%.02fK", likeCount];
    }
    cell.likeCountLabel.text = likesString;
    
    NSString *repostsString = [NSString stringWithFormat:@"%ld", (long)self.feed.reposts_count];
    if (self.feed.reposts_count > 1000) {
        double repostsCount = (double)self.feed.reposts_count/1000;
        repostsString = [NSString stringWithFormat:@"%.02fK", repostsCount];
    }
    cell.repostCountLabel.text = repostsString;
    [cell.authorImageView sd_setImageWithURL:self.feed.source_photo placeholderImage:[UIImage imageNamed:@"ic_user"]];
    cell.authorImageView.layer.cornerRadius = 25;
    cell.authorImageView.clipsToBounds = YES;
    
    if (_feed.photos.count){
        NewsPhoto *newsPhoto = _feed.photos[0];
        if (newsPhoto){
            double aspectRatio = (double)newsPhoto.height/newsPhoto.width;
            double imageViewHeight = cell.frame.size.width*aspectRatio;
            cell.feedImageViewHeightConstraint.constant = imageViewHeight;
            [cell.feedImageView sd_setImageWithURL:newsPhoto.photoURL placeholderImage:[UIImage imageNamed:@"ic_photo"]];
        }
    }
    
    if (self.feed.user_likes) {
        [self.cell.likeImageView setHighlighted:YES];
    } else {
        [self.cell.likeImageView setHighlighted:NO];
    }
    
    UITapGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likePressed)];
    tpgr.numberOfTapsRequired = 1;
    [cell.likeImageView addGestureRecognizer:tpgr];
}

- (void) likePressed {
    NSDictionary *params = @{@"type":@"post",@"owner_id":@(self.feed.source_id), @"item_id":@(self.feed.post_id)};
    __weak typeof(self)weakSelf = self;
    if (self.cell.likeImageView.isHighlighted){
        [self.cell.likeImageView setHighlighted:NO];
        VKRequest* request = [VKRequest requestWithMethod:@"likes.delete" parameters:params];
        self.feed.user_likes = NO;

        [request executeWithResultBlock:^(VKResponse *response) {
            NSDictionary* responseJson = response.json;
            NSInteger newLikesCount = [responseJson[@"likes"] integerValue];
            NSString *likesString = [NSString stringWithFormat:@"%ld", (long)newLikesCount];
            if (weakSelf.feed.likes_count > 1000) {
                double likeCount = (double)newLikesCount/1000;
                likesString = [NSString stringWithFormat:@"%.02fK", likeCount];
            }
            weakSelf.cell.likeCountLabel.text = likesString;
        } errorBlock:^(NSError *error) {
            [weakSelf.cell.likeImageView setHighlighted:YES];
            weakSelf.feed.user_likes = YES;
        }];
    } else {
        [self.cell.likeImageView setHighlighted:YES];
        self.feed.user_likes = YES;
        
        VKRequest* request = [VKRequest requestWithMethod:@"likes.add" parameters:params];
        [request executeWithResultBlock:^(VKResponse *response) {
            NSDictionary* responseJson = response.json;
            NSInteger newLikesCount = [responseJson[@"likes"] integerValue];
            NSString *likesString = [NSString stringWithFormat:@"%ld", (long)newLikesCount];
            if (self.feed.likes_count > 1000) {
                double likeCount = (double)newLikesCount/1000;
                likesString = [NSString stringWithFormat:@"%.02fK", likeCount];
            }
            self.cell.likeCountLabel.text = likesString;
        } errorBlock:^(NSError *error) {
            [self.cell.likeImageView setHighlighted:NO];
            self.feed.user_likes = NO;
        }];
    }
}

@end
