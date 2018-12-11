//
//  Created by Sergei E. on 12/9/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "AMIMainViewController.h"
#import "AMIDevicesListViewController.h"
#import "AMIInfoViewController.h"
#import "AMIStyleConstants.h"

@interface AMIMainViewController () <UITabBarControllerDelegate>

@end

@implementation AMIMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
    [self setupViewControllers];
}

- (void)setupTabBar {
    //self.tabBar.shadowImage = [[UIImage alloc] init];
    //self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.barTintColor = [AMIStyleConstants defaultBackgroundColor];
    self.tabBar.tintColor = [AMIStyleConstants defaultTextColor];
    self.tabBar.translucent = [AMIStyleConstants isNavigationBarTranslucent];
}

- (void)setupViewControllers {
    self.viewControllers = [self createViewControllers];
}

- (NSArray *)createViewControllers {
    UIViewController *devicesVC = [[AMIDevicesListViewController alloc] initWithNibName:@"AMIDevicesListViewController" bundle:nil];
    UINavigationController *devicesNavVC = [[UINavigationController alloc] initWithRootViewController:devicesVC];
    UIImage *devicesVCIcon = [[UIImage imageNamed:@"devices-tab-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    devicesNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Devices" image:devicesVCIcon tag:0];
    
    UIViewController *infoVC = [[AMIInfoViewController alloc] initWithNibName:@"AMIInfoViewController" bundle:nil];
    UIImage *infoVCIcon = [[UIImage imageNamed:@"devices-info-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    infoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Info" image:infoVCIcon tag:1];
    
    return @[devicesNavVC, infoVC];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

@end
