//
//  TLAppDelegate.m
//  Tuplit
//
//  Created by ev_mac6 on 21/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAppDelegate.h"
#import "TLWelcomeViewController.h"
#import <GooglePlus/GooglePlus.h>

#define kAlertQuit      100
#define kAlertDontQuit  101

@implementation TLAppDelegate
@synthesize slideMenuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.defaultColor = UIColorFromRGB(0x00b3a4);
    [CurrentLocation start];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[TLWelcomeViewController alloc] initWithNibName:@"TLWelcomeViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = UIColorFromRGB(0x00998c);
    
    // Changing navigation controller appearance.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:self.defaultColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showNoConnectivityAlertAndQuit:(BOOL)shouldQuit {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"Internet is not reachable. Please check your network connection." delegate:self cancelButtonTitle:shouldQuit?@"Quit":@"OK" otherButtonTitles:nil];
    alert.tag = shouldQuit?kAlertQuit:kAlertDontQuit;
    [alert show];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{    
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
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
