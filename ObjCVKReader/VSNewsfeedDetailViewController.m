//
//  VSNewsfeedDetailViewController.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import "VSNewsfeedDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <VKSdk.h>
#import "ObjCVKReader-Swift.h"
#import <TAPageControl.h>
#import "VSTourDotView.h"

@interface VSNewsfeedDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *repostsCountLabel;
@property (weak, nonatomic) IBOutlet VSTourScrollView *collectionView;
@property (weak, nonatomic) IBOutlet TAPageControl *pageControl;
@property (nonatomic) VSPageControlHelper *helper;
@end

@implementation VSNewsfeedDetailViewController

+ (VSNewsfeedDetailViewController* _Nonnull) instantiate{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.likeCountLabel.text = [_feed likesCountString];
    self.repostsCountLabel.text = [_feed repostsCountString];
    [self.authorImageView sd_setImageWithURL:self.feed.source_photo placeholderImage:[UIImage imageNamed:@"ic_user"]];
    self.feedTextLabel.text = _feed.text;
    self.authorNameLabel.text = _feed.source_name;
    if (self.feed.user_likes) {
        [self.likeImageView setHighlighted:YES];
    } else {
        [self.likeImageView setHighlighted:NO];
    }
    
    UITapGestureRecognizer *tpgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likePressed)];
    tpgr.numberOfTapsRequired = 1;
    [self.likeImageView addGestureRecognizer:tpgr];
    
    NSMutableArray *photoViews = [NSMutableArray new];
    for (NewsPhoto *photo in self.feed.photos) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:photo.photoURL];
        [photoViews addObject:imageView];
    }
    
    if (self.feed.photos.count != 0) {
        [self.collectionView setViewsWithViews:photoViews];
    }
    else {
        for (NSLayoutConstraint *constraint in self.collectionView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 0;
            }
        }
    }
    if (self.feed.photos.count <= 1) {
        [self.pageControl removeFromSuperview];
    } else {
        self.pageControl.numberOfPages = self.feed.photos.count;
        self.pageControl.dotViewClass = [VSTourDotView class];
        self.pageControl.dotSize = CGSizeMake(12.0, 12.0);
        _helper = [[VSPageControlHelper alloc] initWithPageControl:self.pageControl pageScrollView:self.collectionView];
    }
    
}

- (void) likePressed {
    NSDictionary *params = @{@"type":@"post",@"owner_id":@(self.feed.source_id), @"item_id":@(self.feed.post_id)};
    __weak typeof(self)weakSelf = self;
    if (self.likeImageView.isHighlighted){
        [self.likeImageView setHighlighted:NO];
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
            weakSelf.likeCountLabel.text = likesString;
        } errorBlock:^(NSError *error) {
            [weakSelf.likeImageView setHighlighted:YES];
            weakSelf.feed.user_likes = YES;
        }];
    } else {
        [self.likeImageView setHighlighted:YES];
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
            self.likeCountLabel.text = likesString;
        } errorBlock:^(NSError *error) {
            [self.likeImageView setHighlighted:NO];
            self.feed.user_likes = NO;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
