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
#import "Flurry.h"
#import <GooglePlus/GooglePlus.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "TestVersionManager.h"
#import "RefreshBatchCount.h"
#import "TLTutorialViewController.h"

#define kAlertQuit      100
#define kAlertDontQuit  101

@implementation TLAppDelegate

@synthesize slideMenuController,cartModel,isUserProfileEdited,fbSession,isFavoriteChanged,catgDict,vatPercent,isFriendInvited,isSocialhandeled,myProfileVC,merchantVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"6TGJF7C6WTFFNBYDSQ4Z"];
    [Flurry logAllPageViewsForTarget:self.navigationController];
    [Flurry setCrashReportingEnabled:YES];
    [Flurry setDebugLogEnabled:NO];
    [Flurry setBackgroundSessionEnabled:NO];

    self.catgDict = [NSMutableDictionary new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Register Push Notification
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
       [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    if(launchOptions!=nil){
        NSLog(@"Push notification on Launch : %@",[NSString stringWithFormat:@"%@", launchOptions]);
    }
    
    self.defaultColor = UIColorFromRGB(0x00b3a4);
    self.cartModel = [[CartModel alloc] init];
    [self callStaticContentWebService];
    [CurrentLocation start];
    
   welcomeViewController = [[TLWelcomeViewController alloc] initWithNibName:@"TLWelcomeViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    if(!isSocialhandeled)
    {
        [self performSelectorInBackground:@selector(callStaticContentWebService) withObject:nil];
        isSocialhandeled = NO;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if(application.applicationIconBadgeNumber>0)
    {
        RefreshBatchCount * _updateBathCount = [[RefreshBatchCount alloc] init];
        [_updateBathCount updateBadgeCount];
    }
    
    application.applicationIconBadgeNumber = 0;
    [FBSession.activeSession handleDidBecomeActive];
    
//#if DEBUG
//    
//#else
//    [[TestVersionManager sharedManager] validateCurrentAppVersion];
//#endif
    
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
    self.isSocialhandeled = NO;
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
    
    NSLog(@"push dict = %@", dict);
    
    if ([[dict objectForKey:@"type"] intValue] == 2) { //create Order
        
        NSString *processId = [dict objectForKey:@"processId"];
        
        TLOrderDetailViewController *orderDetailVC = [[TLOrderDetailViewController alloc] init];
        orderDetailVC.orderID = processId;
        
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:orderDetailVC];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
        
    }
    else if ([[dict objectForKey:@"type"] intValue] == 1)  // transfer or topup
    {
        
        [TuplitConstants openMyProfile];
        
        NSString *msgStr = [dict objectForKey:@"notes"];
        NSString *msgTitle = [dict objectForKey:@"alert"];
        NSString *senderName = msgTitle;
        [UIAlertView alertViewWithTitle:senderName message:msgStr];
    }
    else if ([[dict objectForKey:@"type"] intValue] == 3)  // Approve order
    {
        NSString *processId = [dict objectForKey:@"processId"];
        NSString *merchantId = [dict objectForKey:@"merchantId"];
        NSString *merchantName = [dict objectForKey:@"merchantName"];
        
        TLOrderConformViewController *orderConfromView = [[TLOrderConformViewController alloc]init];
        orderConfromView.orderStatus = @"1";
        orderConfromView.orderID = processId;
        orderConfromView.merchatID = merchantId;
        orderConfromView.merchatName = merchantName;
        
         UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:orderConfromView];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
    }
    else if ([[dict objectForKey:@"type"] intValue] == 4) // Reject order
    {
        NSString *processId = [dict objectForKey:@"processId"];
        NSString *merchantId = [dict objectForKey:@"merchantId"];
        NSString *merchantName = [dict objectForKey:@"merchantName"];
        NSString *refundAmt = [dict objectForKey:@"OrderAmount"];
        
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
//        NSString *string = topUpAmountTxt.text;
//        NSString *topUpAmount = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
        
        UserModel *userModel = [TLUserDefaults getCurrentUser];
        double balance = userModel.AvailableBalance.doubleValue;
        userModel.AvailableBalance = [NSString stringWithFormat:@"%lf",(balance + refundAmt.doubleValue)];
        [TLUserDefaults setCurrentUser:userModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserData object:nil];
        
        TLOrderConformViewController *orderConfromView = [[TLOrderConformViewController alloc]init];
        orderConfromView.orderStatus = @"3";
        orderConfromView.orderID = processId;
        orderConfromView.merchatID = merchantId;
        orderConfromView.merchatName = merchantName;
        
        UINavigationController *slideNavigationController = [[UINavigationController alloc] initWithRootViewController:orderConfromView];
        [APP_DELEGATE.slideMenuController setContentViewController:slideNavigationController animated:YES];
        [APP_DELEGATE.slideMenuController hideMenuViewController];
    }
}

-(void) dealloc {
    
    staticContentManager.delegate = nil;
    staticContentManager = nil;
}

#pragma mark - User defined methods

-(void) callStaticContentWebService {
    
    NETWORK_TEST_PROCEDURE
    if(!staticContentManager) {
        staticContentManager = [TLStaticContentManager new];
        staticContentManager.delegate = self;
    }
    [staticContentManager getStaticContents];
}

-(void)callUserService
{
    //    [[ProgressHud shared] showWithMessage:@"" inTarget:self.navigationController.view];
    TLUserDetailsManager *userDetailsManager = [TLUserDetailsManager new];
    userDetailsManager.delegate = self;
    [userDetailsManager getUserDetailsWithUserID:[TLUserDefaults getCurrentUser].UserId];
    
}

#pragma mark - Perform facebook login

-(void)doFacebookLogin:(UIViewController*) viewController
{
    //Clear if any saved or cached tokan available
    [FBSession.activeSession closeAndClearTokenInformation];
    
    // premissions
    NSArray *permissions = [NSArray arrayWithObjects:@"email",@"user_birthday",nil];
//public_profile",@"read_friendlists",@"user_friends
    
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        
        switch (state)
        {
            case FBSessionStateOpen:
            {
                NSLog(@"status : FBSessionStateOpen");
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"id,name,first_name,last_name,email,birthday,gender,picture.type(large),link,locale,updated_time,verified" forKey:@"fields"];
                [[FBRequest requestWithGraphPath:@"me" parameters:dict HTTPMethod:nil] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                    
                    NSLog(@"user  :%@",user);
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
    
    for(NSString *urls in [Global instance].tutorialScreenImages)
    {
//        EGOImageView *imageview = [[EGOImageView alloc]initWithPlaceholderImage:nil imageViewFrame:CGRectMake(0, 0, 10, 10)];
        EGOImageView *imageview = [[EGOImageView alloc]initWithPlaceholderImage:nil delegate:self];
//        imageview.delegate = self;
        imageview.imageURL = [NSURL URLWithString:urls];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWelcomeScreenSlideShowStarter object:nil];
}

- (void)staticContentManager:(TLStaticContentManager *)staticContentManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
}

- (void)staticContentManagerFailed:(TLStaticContentManager *)staticContentManager {
    
}

#pragma mark - TLUserDetailsManagerDelegate methods

- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_ {
    
    [TLUserDefaults setCurrentUser:user_];
    [[ProgressHud shared] hide];
}

- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:errorMsg];
}

- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager {
    
    [[ProgressHud shared] hide];
    [UIAlertView alertViewWithMessage:LString(@"SERVER_CONNECTION_ERROR")];
}

#pragma mark - EGOImageViewDelegate

- (void)imageViewLoadedImage:(EGOImageView*)imageView {

    
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error {
    
}


@end
