//
//  AuthControllerViewController.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04/02/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

#import "AuthControllerViewController.h"
#import "VSVKAuthenticator.h"
#import "VSNewsViewController.h"

@interface AuthControllerViewController ()
@property VSVKAuthenticator* vkAuthenticator;
@end

@implementation AuthControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _vkAuthenticator = [[VSVKAuthenticator alloc] initWithPresenter:self];
    [_vkAuthenticator checkStatusWithHandler:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationInitialized) {
            //load Login controller
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = viewController;
        } else if (state == VKAuthorizationAuthorized) {
            //open news
            UIViewController* newsController = [VSNewsViewController instantiate];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = newsController;
        } else if (error) {
            // Some error happend, but you may try later
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = viewController;
        } else {
            //Unknown state
            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = viewController;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
