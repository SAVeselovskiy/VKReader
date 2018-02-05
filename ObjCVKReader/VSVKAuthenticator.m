//
//  VSVKAuthenticator.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import "VSVKAuthenticator.h"

static NSArray  * SCOPE = nil;
@interface VSVKAuthenticator  () <VKSdkDelegate, VKSdkUIDelegate>
@property NSError* error;
@property VKAccessToken *vkToken;
@end

@implementation VSVKAuthenticator

-(instancetype) initWithPresenter:(UIViewController*) presenter{
    self = [super init];
    self.presenter = presenter;
    return self;
}

-(void) cleanClosures{
    _successClosure = nil;
    _failureClosure = nil;
}

- (void) checkStatusWithHandler: (void(^)(VKAuthorizationState state, NSError * error)) handler{
    SCOPE = @[VK_PER_WALL, VK_PER_FRIENDS, VK_PER_OFFLINE];
    VKSdk * vkSdkInstance = [VKSdk initializeWithAppId:@"6181415"];
    [vkSdkInstance registerDelegate:self];
    [vkSdkInstance setUiDelegate:self];
    
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        handler(state, error);
    }];
}

- (void)signIn{
    SCOPE = @[VK_PER_WALL, VK_PER_FRIENDS, VK_PER_OFFLINE];
    VKSdk * vkSdkInstance = [VKSdk initializeWithAppId:@"6181415"];
    [vkSdkInstance registerDelegate:self];
    [vkSdkInstance setUiDelegate:self];

    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        NSString* states = @"0: VKAuthorizationUnknown\n1: VKAuthorizationInitialized\n2: VKAuthorizationPending\n3: VKAuthorizationExternal\n4: VKAuthorizationSafariInApp\n5: VKAuthorizationWebview\n6: VKAuthorizationAuthorized\n7: VKAuthorizationError";
        if (state == VKAuthorizationInitialized) {
            [VKSdk authorize:SCOPE];
        } else if (state == VKAuthorizationAuthorized) {
            _successClosure([VKSdk accessToken]);
        } else if (error) {
            // Some error happend, but you may try later
            _failureClosure (error);
            NSLog(@"signInVkPressed Error %@, state: %lu. Find your state:) :\n%@",error, (unsigned long)state, states);
        } else {
            NSLog(@"Not handled VKAuthorizationState: %lu, Find your state:) :\n%@", (unsigned long)state, states);
            _failureClosure (nil);
        }
    }];
}

#pragma mark - vk ui delegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.presenter presentViewController:controller animated:YES completion:nil];
}


- (void)vkSdkDidDismissViewController:(UIViewController *)controller{
    if (self.error){
        self.failureClosure(self.error);
    }
    else{
        self.successClosure(self.vkToken);
    }
}

#pragma mark - vk delegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.error) {
        NSLog(@"vkSdkUserAuthorizationFailed %@",result.error);
        self.error = result.error;
    } else {
        self.vkToken = result.token;
    }
}

/**
 Notifies delegate about access error, mostly connected with user deauthorized application
 */


@end
