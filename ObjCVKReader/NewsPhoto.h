//
//  NewsPhoto.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsPhoto : NSObject <NSCoding>
@property NSURL *photoURL;
@property NSInteger width;
@property NSInteger height;
- (instancetype)initWithURL: (NSURL*) photoURL width: (NSInteger) width height: (NSInteger) height;
@end
