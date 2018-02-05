//
//  VSNewsViewController.m
//  ObjCVKReader
//
//  Created by Сергей Веселовский on 04.02.18.
//  Copyright © 2017 Сергей Веселовский. All rights reserved.
//

#import "VSNewsViewController.h"
#import "VSNewsPresenter.h"
#import <VKSdk.h>

@interface VSNewsViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) id<VSNewsPresenterProtocol, UITableViewDataSource> presenter;
@property UIRefreshControl *refreshControl;
@end

@implementation VSNewsViewController

+ (VSNewsViewController *) instantiate{
    return [[UIStoryboard storyboardWithName:@"NewsList" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.presenter = [[VSNewsPresenter alloc] initWithView:self];
    [self.presenter viewDidLoad];
    self.tableView.dataSource = self.presenter;
    self.tableView.delegate = self;
    self.title = NSLocalizedString(@"News", @"");
    // Do any additional setup after loading the view.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_exit"] style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
}

- (void) logout {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Do you want to logout?", @"")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [VKSdk forceLogout];
        UIViewController* loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                             instantiateViewControllerWithIdentifier:@"LoginVC"];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = loginController;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) insertNews:(NSArray<Newsfeed*>*) news startAt:(NSInteger) startIndex {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = 0; i < news.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:startIndex + i inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void) reloadView{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refresh{
    [self.presenter refreshList];
}

#pragma mark VSNewsViewProtocol

- (void) showError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) endRefreshing{
    [self.refreshControl endRefreshing];
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.presenter didClickOnCellWithIndex:indexPath.row];
}
- (void) pushController: (UIViewController*) viewController animated: (BOOL) animated{
    [self.navigationController pushViewController:viewController animated:true];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
