//
//  Created by Sergei E. on 12/7/18.
//  (c) 2018 Ambrosus. All rights reserved.
//

#import "AMIAppDelegate.h"
#import "AMIMainViewController.h"

@interface AMIAppDelegate ()
@end

@implementation AMIAppDelegate

- (void)dealloc {
    self.window = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *vc = [[AMIMainViewController alloc] initWithNibName:@"AMIMainViewController" bundle:nil];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    self.window = window;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
