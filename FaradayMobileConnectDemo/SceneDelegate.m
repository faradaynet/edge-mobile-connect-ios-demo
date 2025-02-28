//
//  SceneDelegate.m
//  FaradayEdgeMobileConnect
//

#import "SceneDelegate.h"
#import "FaradayEdgeMobileConnect-Swift.h"
#import "DeeplinkManager.h"



@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)sceneDidDisconnect:(UIApplication *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIApplication *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIApplication *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIApplication *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIApplication *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

- (void)scene:(UIScene *)scene
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

- (BOOL)scene:(UIScene *)scene
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
