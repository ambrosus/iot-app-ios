//
//  Created by Sergei E. on 12/10/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "AMIDevicesListViewController.h"
#import "AMIStyleConstants.h"

@interface AMIDevicesListViewController ()

@end

@implementation AMIDevicesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [AMIStyleConstants defaultBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
