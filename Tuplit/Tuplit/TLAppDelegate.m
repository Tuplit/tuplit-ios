//
//  TLAppDelegate.m
//  Tuplit
//
//  Created by ev_mac6 on 21/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLAppDelegate.h"
#import "TLOrderDetailViewController.h"
#import "TLSignUpViewController.h"

#import <GooglePlus/GooglePlus.h>

#define kAlertQuit      100
#define kAlertDontQuit  101

@implementation TLAppDelegate

@synthesize slideMenuController,cartModel,isUserProfileEdited,fbSession,isFavoriteChanged,catgDict;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.catgDict = [NSMutableDictionary new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Register Push Notification
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if(launchOptions!=nil){
        NSLog(@"Push notification on Launch : %@",[NSString stringWithFormat:@"%@", launchOptions]);
    }
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.defaultColor = UIColorFromRGB(0x00b3a4);
    self.cartModel = [[CartModel alloc] init];
    
    [CurrentLocation start];
    
    welcomeViewController = [[TLWelcomeViewController alloc] initWithNibName:@"TLWelcomeViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = UIColorFromRGB(0x00998c);
    [self.window makeKeyAndVisible];
        
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
    application.applicationIconBadgeNumber = 0;
    
    [self performSelectorInBackground:@selector(callStaticContentWebService) withObject:nil];
    [FBSession.activeSession handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showNoConnectivityAlertAndQuit:(BOOL)shouldQuit {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LString(@"TUPLIT") message:@"Internet is not reachable. Please check your network connection." delegate:self cancelButtonTitle:shouldQuit?@"Quit":@"OK" otherButtonTitles:nil];
    alert.tag = shouldQuit?kAlertQuit:kAlertDontQuit;
    [alert show];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    NSString * urlString  = [NSString stringWithFormat:@"%@",url];
    if ([urlString rangeOfString:@"fb"].location == NSNotFound) {
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    } else {
        return [[FBSession activeSession] handleOpenURL:url];
    }
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
	NSLog(@"deviceToken: %@", deviceToken);
    [TLUserDefaults setDeviceToken:[NSString stringWithFormat:@"%@",deviceToken]];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSDictionary *dict = [userInfo objectForKey:@"aps"];
    
    if ([[dict objectForKey:@"type"] intValue] == 2) {
        
        NSString *processId = [dict objectForKey:@"processId"];
        
        TLOrderDetailViewController *orderDetailVC = [[TLOrderDetailViewController alloc] init];
        orderDetailVC.orderID = processId;
        
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:orderDetailVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
        
    }
    else if ([[dict objectForKey:@"type"] intValue] == 1)
    {
        TLUserProfileViewController *myProfileVC = [[TLUserProfileViewController alloc] init];
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:myProfileVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        
        [APP_DELEGATE.slideMenuController hideMenuViewController];
    }
}

-(void) dealloc {
    
    staticContentManager.delegate = nil;
    staticContentManager = nil;
}

-(void) callStaticContentWebService {
    
    if(!staticContentManager) {
        staticContentManager = [TLStaticContentManager new];
        staticContentManager.delegate = self;
    }
    [staticContentManager getStaticContents];
}

#pragma mark - Perform facebook login

-(void)doFacebookLogin:(UIViewController*) viewController
{
    //Clear if any saved or cached tokan available
    [FBSession.activeSession closeAndClearTokenInformation];
    
    // premissions
    NSArray *permissions = [NSArray arrayWithObjects:@"read_friendlists",@"user_birthday",@"email",nil];
//public_profile",@"read_friendlists",@"user_friends
    
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        
        switch (state)
        {
            case FBSessionStateOpen:
            {
                NSLog(@"status : FBSessionStateOpen");
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"id,name,first_name,last_name,email,birthday,gender,picture.type(large),link,locale,updated_time,verified" forKey:@"fields"];
                [[FBRequest requestWithGraphPath:@"me" parameters:dict HTTPMethod:nil] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    
                    if ([viewController isKindOfClass:[TLWelcomeViewController class]]) {
                        
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBWelcomeScreen object:user];
                        }
                        else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBWelcomeScreen object:nil];
                        }
                        
                    }
                    else if([viewController isKindOfClass:[TLSignUpViewController class]])
                    {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBSignupScreen object:user];
                        }
                        else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBSignupScreen object:nil];
                        }
                    }
                }];
                break;
            }
            case FBSessionStateOpenTokenExtended:
            {
                NSLog(@"status : FBSessionStateOpenTokenExtended");
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"id,name,first_name,last_name,email,birthday,gender,picture.type(large),link,locale,updated_time,verified" forKey:@"fields"];
                [[FBRequest requestWithGraphPath:@"me" parameters:dict HTTPMethod:nil] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    
                    if ([viewController isKindOfClass:[TLWelcomeViewController class]]) {
                        
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBWelcomeScreen object:user];
                        }
                        else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBWelcomeScreen object:nil];
                        }
                        
                    }
                    else if([viewController isKindOfClass:[TLSignUpViewController class]])
                    {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBSignupScreen object:user];
                        }
                        else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kFBSignupScreen object:nil];
                        }
                    }
                }];
                break;
            }
            case FBSessionStateClosed:
            {
                NSLog(@"status : FBSessionStateClosed");
                break;
            }
            case FBSessionStateClosedLoginFailed :
            {
                NSLog(@"status : FBSessionStateCloseNSLoginFailed");
                if ([viewController isKindOfClass:[TLWelcomeViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFBWelcomeScreen object:nil];
                }
                else if ([viewController isKindOfClass:[TLSignUpViewController class]]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFBSignupScreen object:nil];
                }
                break;
            }
            default:
            {
                break;
            }
        }
    }];
}

#pragma mark - TLStaticContentManager delegate methods

- (void)staticContentManagerSuccess:(TLStaticContentManager *)staticContentManager {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWelcomeScreenSlideShowStarter object:nil];
}

- (void)staticContentManager:(TLStaticContentManager *)staticContentManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    
}

- (void)staticContentManagerFailed:(TLStaticContentManager *)staticContentManager {
    
}

@end
