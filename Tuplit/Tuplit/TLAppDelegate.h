//
//  TLAppDelegate.h
//  Tuplit
//
//  Created by ev_mac6 on 21/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLMerchantsViewController.h"
#import "TLUserProfileViewController.h"
#import "TLCartViewController.h"
#import "TLFriendsViewController.h"
#import "TLSettingsViewController.h"
#import "RESideMenu.h"
#import "CartModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TLStaticContentManager.h"
#import "TLWelcomeViewController.h"

@interface TLAppDelegate : UIResponder <UIApplicationDelegate,TLStaticContentManagerDelegate>
{
     FBSession *fbSession;
     TLStaticContentManager *staticContentManager;
     TLWelcomeViewController *welcomeViewController;
}

@property (strong, nonatomic) FBSession *fbSession;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UIColor *defaultColor;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) RESideMenu *slideMenuController;
@property (strong, nonatomic) CartModel *cartModel;
@property (strong, nonatomic) NSArray *friendsRecentOrders;
@property (strong, nonatomic) NSString *merchantID;
@property (assign, nonatomic) BOOL isUserProfileEdited,isFavoriteChanged;
@property (strong, nonatomic) NSMutableDictionary *catgDict;

- (void)showNoConnectivityAlertAndQuit:(BOOL)shouldQuit;

-(void)doFacebookLogin:(UIViewController*) viewController;
@end
