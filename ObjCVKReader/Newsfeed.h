//
//  Newsfeed.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsPhoto.h"

@interface Newsfeed : NSObject <NSCoding>
@property long source_id;
@property NSTimeInterval date;
@property NSString *text;
@property NSInteger likes_count;
@property NSInteger reposts_count;
@property NSArray<NewsPhoto*> *photos;
@property NSNumber* signer_id;
@property BOOL user_likes;
@property BOOL user_reposted;
@property long post_id;
@property NSString *source_name;
@property NSURL *source_photo;
@property NSString *next_from;

- (NSString*) likesCountString;
- (NSString*) repostsCountString;

- (NSData*) getData;
+ (instancetype) initFromData:(NSData*) data;

@end
