//
//  Newsfeed.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import "Newsfeed.h"

@implementation Newsfeed
- (NSString*) likesCountString {
    NSString *likesString = [NSString stringWithFormat:@"%ld", (long)self.likes_count];
    if (self.likes_count > 1000) {
        double likeCount = (double)self.likes_count/1000;
        likesString = [NSString stringWithFormat:@"%.02fK", likeCount];
    }
    return likesString;
}

- (NSString*) repostsCountString {
    NSString *repostsString = [NSString stringWithFormat:@"%ld", (long)self.reposts_count];
    if (self.reposts_count > 1000) {
        double likeCount = (double)self.reposts_count/1000;
        repostsString = [NSString stringWithFormat:@"%.02fK", likeCount];
    }
    return repostsString;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_post_id forKey:@"post_id"];
    [aCoder encodeDouble:_date forKey:@"date"];
    [aCoder encodeObject:_text forKey:@"text"];
    [aCoder encodeInteger:_likes_count forKey:@"likes_count"];
    [aCoder encodeInteger:_reposts_count forKey:@"reposts_count"];
    [aCoder encodeObject:_photos forKey:@"photos"];
    [aCoder encodeObject:_signer_id forKey:@"signer_id"];
    [aCoder encodeBool:_user_likes forKey:@"user_likes"];
    [aCoder encodeBool:_user_reposted forKey:@"user_reposted"];
    [aCoder encodeObject:_source_name forKey:@"source_name"];
    [aCoder encodeObject:_source_photo forKey:@"source_photo"];
    [aCoder encodeObject: _next_from forKey:@"next_from"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.post_id = [aDecoder decodeIntegerForKey:@"post_id"];
    self.date = [aDecoder decodeDoubleForKey:@"date"];
    self.text = [aDecoder decodeObjectForKey:@"text"];
    self.likes_count = [aDecoder decodeIntegerForKey:@"likes_count"];
    self.reposts_count = [aDecoder decodeIntegerForKey:@"reposts_count"];
    self.photos = [aDecoder decodeObjectForKey:@"photos"];
    self.signer_id = [aDecoder decodeObjectForKey:@"signer_id"];
    self.user_likes = [aDecoder decodeBoolForKey:@"user_likes"];
    self.user_reposted = [aDecoder decodeBoolForKey:@"user_reposted"];
    self.source_name = [aDecoder decodeObjectForKey:@"source_name"];
    self.source_photo = [aDecoder decodeObjectForKey:@"source_photo"];
    self.next_from = [aDecoder decodeObjectForKey:@"next_from"];
    return self;
}

- (NSData*) getData {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

+ (instancetype) initFromData:(NSData*) data {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (instancetype)initWithSourceId: (long) source_id
                            date: (NSTimeInterval) date
                            text: (NSString *)text
                      likesCount:(NSInteger) likes_count
                    repostsCount:(NSInteger) reposts_count
                          photos:(NSArray<NewsPhoto*> *) photos
                        signerId: (NSNumber*) signer_id
                       userLikes: (BOOL) user_likes
                    userReposted: (BOOL) userReposted postId:(long) post_id
                      sourceName:(NSString*) source_name
                     sourcePhoto:(NSURL*) source_photo
                        nextFrom: (NSString*) next_from

{
    self = [super init];
    if (self) {
        self.source_id = source_id;
        self.date = date;
        self.text = text;
        self.likes_count = likes_count;
        self.reposts_count = reposts_count;
        self.photos = photos;
        self.signer_id = signer_id;
        self.user_likes = user_likes;
        self.user_reposted = userReposted;
        self.source_name = source_name;
        self.source_photo = source_photo;
        self.next_from = next_from;
    }
    return self;
}

@end
