//
//  BTTAppDelegate.m
//  Insist100Days
//
//  Created by qatang on 06/04/13.
//  Copyright (c) 2013 qatang. All rights reserved.
//

#import "BTTAppDelegate.h"
#import "BTTIndexController.h"
#import "BTTDatabaseUtil.h"
#import "BTTConfig.h"

@implementation BTTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    FMDatabase *db = [[BTTDatabaseUtil shared]db];

    int versionCurrent = [BTTDatabaseUtil schemaVersion:db];
    if (versionCurrent == 0) {
        [BTTDatabaseUtil initSchema:db];
    } else {
        [BTTDatabaseUtil migrateDB:db fromVersion:versionCurrent toVersion:BTT_DB_SCHEMA_VERSION];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    BTTIndexController *indexController = [[BTTIndexController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:indexController];
    self.window.rootViewController = indexController;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end