//
//  Created by Sergei E. on 12/9/18.
//  (c) 2018 Ambrosus. All rights reserved.
//  

#import "AMIMainViewController.h"
#import "AMIInfoViewController.h"
#import "UIImage+PDF.h"
#import "L2ios-Swift.h"

@interface AMIMainViewController () <UITabBarControllerDelegate>

@end

@implementation AMIMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    [self setupTabBar];
    [self setupTabbedControllers];
}

- (void)setupTabBar {
    AMIStyleConstants *styleConstants = [AMIStyleConstants sharedInstance];
    
    self.tabBar.barTintColor = [styleConstants navigationBarColor];
    self.tabBar.tintColor = [styleConstants brightTextColor];
    self.tabBar.translucent = [styleConstants isNavigationBarTranslucent];
}

- (void)setupTabbedControllers {
    UIViewController *devicesVC = [[AMIDevicesListViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *devicesNavVC = [[UINavigationController alloc] initWithRootViewController:devicesVC];
    UIViewController *infoVC = [[AMIInfoViewController alloc] initWithNibName:@"AMIInfoViewController" bundle:nil];
    NSArray *viewControllers = @[devicesNavVC, infoVC];
    [self _assignViewControllers:viewControllers tabNames:@[@"Devices", @"More"] tabImages:@[@"icdev.pdf", @"ic-more.pdf"]];
    
    self.viewControllers = viewControllers;
}

- (void)_assignViewControllers:(NSArray *)vcs tabNames:(NSArray *)tabNames tabImages:(NSArray *)tabImageNames {
    NSAssert(vcs.count > 0 && tabNames.count == vcs.count && tabImageNames.count == vcs.count, @"Bad args");
    NSInteger index = 0;
    for (UIViewController *vc in vcs) {
        NSString *tabName = tabNames[index];
        NSString *tabImageName = tabImageNames[index];
        UIImage *tabImage = nil;
        if ([tabImageName hasSuffix:@".pdf"]) {
            tabImage = [UIImage imageWithPDFNamed:tabImageName atHeight:21];
        }
        else {
            tabImage = [UIImage imageNamed:tabImageName];
        }
        
        tabImage = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabName image:tabImage tag:index];
        index++;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

@end
