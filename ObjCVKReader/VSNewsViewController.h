//
//  VSNewsViewController.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Newsfeed;

@protocol VSNewsViewProtocol <NSObject>
- (void) reloadView;
- (void) insertNews:(NSArray<Newsfeed*>*) news startAt:(NSInteger) startIndex;
- (void) showError:(NSError*) error;
- (void) endRefreshing;
- (void) pushController: (UIViewController*) viewController animated: (BOOL) animated;
@end

@interface VSNewsViewController : UIViewController <VSNewsViewProtocol>
+ (VSNewsViewController *) instantiate;
@end
