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

@interface TLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UIColor *defaultColor;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) RESideMenu *slideMenuController;
@property (strong, nonatomic) CartModel *cartModel;
@property (strong, nonatomic) NSString *merchantID;
@property (assign, nonatomic) BOOL isUserProfileEdited;

- (void)showNoConnectivityAlertAndQuit:(BOOL)shouldQuit;
@end
