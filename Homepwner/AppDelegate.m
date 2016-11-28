//
//  AppDelegate.m
//  Homepwner
//
//  Created by Liu on 16/10/12.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"

NSString * const BNRNextItemValuePrefsKey = @"NextItemValue";
NSString * const BNRNextItemNamePrefsKey = @"NextItemName";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (!self.window.rootViewController) {
        BNRItemsViewController *itemsViewController = [[BNRItemsViewController alloc] init];

        // self.window.rootViewController = itemsViewController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        self.window.rootViewController = navController;
    }


    //self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL saveItemsDone = [[BNRItemStore sharedStore] saveItems];
    if (saveItemsDone) {
        NSLog(@"items save done");
    } else {
        NSLog(@"items save faild");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UINavigationController *vc = [[UINavigationController alloc] init];

    vc.restorationIdentifier = [identifierComponents lastObject];

    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }

    return vc;
}

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{BNRNextItemNamePrefsKey: @"Coffe Cup", BNRNextItemValuePrefsKey: @75};
    [defaults registerDefaults:factorySettings];
}

@end
