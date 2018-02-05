//
//  LoginViewController.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import "LoginViewController.h"
#import "VSVKAuthenticator.h"
#import <VK-ios-sdk/VKSdk.h>
#import "VSNewsViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property VSVKAuthenticator* vkAuthenticator;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.authButton.layer.cornerRadius = 7.0;
    
    
    _vkAuthenticator = [[VSVKAuthenticator alloc] initWithPresenter:self];
    __weak typeof(self) weakSelf = self;
    _vkAuthenticator.failureClosure = ^(NSError * _Nullable error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    _vkAuthenticator.successClosure = ^(VKAccessToken * _Nullable token) {
        [weakSelf showViewController:[VSNewsViewController instantiate] sender:weakSelf];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)authAction:(id)sender {
    [_vkAuthenticator signIn];
    
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
