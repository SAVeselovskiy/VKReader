//
//  VSReachabilityManager.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 05/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import "VSReachabilityManager.h"

#import "Reachability.h"

@interface VSReachabilityManager()
@property (nonatomic, retain) Reachability *reach;
@end

@implementation VSReachabilityManager

+ (VSReachabilityManager *)sharedManager
{
    static VSReachabilityManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        NSString * url = @"http://vk.com";
        NSString * host = [[url componentsSeparatedByString:@"//"] objectAtIndex:1];
        self.reach = [Reachability reachabilityWithHostname:host];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [self.reach startNotifier];
    }
    return self;
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability *r = [note object];
    
    if (![r isReachableViaWiFi]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationWifiDisabled" object:nil];
    }
    
    if ([r isReachable])  {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationReachable" object:nil];
    } else {
        //        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
        //                                                             message:@"Connection Lost"
        //                                                            delegate:nil
        //                                                   cancelButtonTitle:@"OK"
        //                                                   otherButtonTitles:nil];
        //        [errorAlert show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationNotReachable" object:nil];
    }
}

- (BOOL)isReachable
{
    return self.reach.isReachable;
}

@end

