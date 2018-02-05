//
//  NewsCellModel.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCell.h"
#import "Newsfeed.h"

@interface NewsCellModel : NSObject
- (Newsfeed*) getFeed;
- (instancetype)initWithEntity:(Newsfeed*) feed;
- (void) fillCell:(NewsCell*) cell;
@end
