//
//  AppDelegate.m
//  FaradayEdgeMobileConnect
//

#import "AppDelegate.h"
#import "DeeplinkManager.h"
#import "FaradayEdgeMobileConnect-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)application:(UIScene *)scene
    willConnectToSession:(UISceneSession *)session
    options:(UISceneConnectionOptions *)connectionOptions {
    
    if (connectionOptions.userActivities.count > 0) {
        NSUserActivity *userActivity = connectionOptions.userActivities.allObjects.firstObject;
        if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
            NSURL *url = userActivity.webpageURL;
            [DeeplinkManager shared].deeplinkURL = url;
            [self navigateToMainViewController];
        }
    }
}

- (BOOL)application:(UIScene *)scene
  continueUserActivity:(NSUserActivity *)userActivity {
    
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if (url) {
            [DeeplinkManager shared].deeplinkURL = url;
            [self navigateToMainViewController];
        }
        return YES;
    }
    return NO;
}

- (void)navigateToMainViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    WifiViewController *wifiVC = [storyboard instantiateViewControllerWithIdentifier:@"WifiViewController"];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wifiVC];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

}


@end
