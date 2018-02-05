//
//  VSNewsfeedDetailViewController.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Newsfeed.h"

@interface VSNewsfeedDetailViewController : UIViewController
@property Newsfeed* _Nullable feed;
+ (VSNewsfeedDetailViewController* _Nonnull) instantiate;
@end
