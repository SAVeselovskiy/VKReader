//
//  VSNewsModel.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSNewsPresenter.h"

@protocol VSNewsModelProtocol <NSObject>
- (void) loadNewsWithCount: (NSInteger) count startFrom: (NSString*) startFrom;
- (void) loadCachedNewsWithCount: (NSInteger) count startFrom: (NSString*) startFrom;
- (instancetype)initWithPresenter:(id <VSNewsPresenterProtocol>) preseneter;
- (void) deleteSavedNews;
@end

@interface VSNewsModel : NSObject <VSNewsModelProtocol>

@end
