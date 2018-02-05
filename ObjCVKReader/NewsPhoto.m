//
//  NewsPhoto.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import "NewsPhoto.h"

@implementation NewsPhoto
- (instancetype)initWithURL: (NSURL*) photoURL width: (NSInteger) width height: (NSInteger) height
{
    self = [super init];
    if (self) {
        self.photoURL = photoURL;
        self.width = width;
        self.height = height;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_width forKey:@"width"];
    [aCoder encodeInteger:_height forKey:@"height"];
    [aCoder encodeObject:_photoURL forKey:@"photoURL"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.width = [aDecoder decodeIntegerForKey:@"width"];
    self.height = [aDecoder decodeIntegerForKey:@"height"];
    self.photoURL = [aDecoder decodeObjectForKey:@"photoURL"];
    return self;
}

@end
