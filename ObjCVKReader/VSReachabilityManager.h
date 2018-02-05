//
//  VSReachabilityManager.h
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 05/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSReachabilityManager : NSObject
+ (VSReachabilityManager *)sharedManager;
- (BOOL)isReachable;
@end
