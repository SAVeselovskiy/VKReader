//
//  VSNewsPresenter.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Newsfeed.h"
#import "VSNewsViewController.h"

@protocol VSNewsPresenterProtocol <NSObject> //надо бы разделить по двум протоколам, для view и model
- (void) viewDidLoad;
- (void) didLoadNewsPart: (NSArray<Newsfeed *>*) newsFeed startFrom: (NSString*) start_from;
- (void) didFailLoadNews:(NSError*) error;
- (instancetype)initWithView:(id <VSNewsViewProtocol>) view;
- (void) didClickOnCellWithIndex:(NSInteger) index;
- (void) refreshList;
@end

@interface VSNewsPresenter : NSObject <VSNewsPresenterProtocol, UITableViewDataSource>

@end
