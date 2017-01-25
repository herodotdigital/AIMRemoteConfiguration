//
//  AppDelegate.m
//  RemoteConfiguration
//
//  Created by Maciej Gad on 18.01.2017.
//  Copyright © 2017 Maciej Gad. All rights reserved.
//

#import "AppDelegate.h"
#import "RemoteConfiguration.h"

static const NSTimeInterval BackgoundTimeNeededToUpdateConfig = 10;

@interface AppDelegate ()
@property (strong, nonatomic) NSDate *resignActiveDate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RemoteConfiguration setup];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    self.resignActiveDate = [NSDate date];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSTimeInterval backgroundLength = [[NSDate date] timeIntervalSinceDate:self.resignActiveDate];
    printf("resign active date:%s, diff: %f\n", [self.resignActiveDate description].UTF8String, backgroundLength);
    if(backgroundLength > BackgoundTimeNeededToUpdateConfig) {
        [self reloadConfiguration];
    }
}

- (void)reloadConfiguration {
    [RemoteConfiguration useFutureConfiguration];
    [RemoteConfiguration update];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    UIViewController *start = [storyboard instantiateInitialViewController];
    self.window.rootViewController = start;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
