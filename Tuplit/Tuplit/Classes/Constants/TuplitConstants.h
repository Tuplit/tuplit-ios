//
//  TuplitConstants.h
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TLAppDelegate.h"
#import "NetworkConnectivity.h"


/******** APPDELEGATE ********/
#define APP_DELEGATE							((TLAppDelegate *)[[UIApplication sharedApplication] delegate])


/******** INDEX OF VIEW IN ARRAY *****/
#define IndexOfMerchantVC   0
#define IndexOfCartVC       1
#define IndexOfFriendsVC    2
#define IndexOfSettingsVC   3

/******** COLOR *********/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/********** SYSTEM VERSION  *********/
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/******** APP Id's ********/
static NSString * const kClientId = @"120599738577-saq9v1g8an1n67sjc534cabeeape34h1.apps.googleusercontent.com";

#define FacebookAppID            @"1443093035941769"

#define CLIENTID              @"8acc207693494259fd435dd54915fe9b6465d3a7"
#define CLIENT_SECRET_ID      @"b915d9fed580e700b8831be8c8ecd0cb205fce57"

/***** CREDIT CARD NUMBER USING SCAN.IO *****/

#define CardIOAppToken      @"f689bfbe34ce4f938c7a3dfbdb8b0dd0"

/******** NETWORK TEST PROCEDURE ********/
#define NETWORK_TEST_PROCEDURE          if (![NetworkConnectivity hasConnectivity]) { [APP_DELEGATE showNoConnectivityAlertAndQuit:NO]; return; }

#define DISMISS_KEYBOARD [self.view endEditing:YES]

/******** WEB SERVICE END-POINTS ********/

#if DEBUG

    #define RESOURCE_URL                @"http://172.21.4.104/tuplit"

#else

    #define RESOURCE_URL                @"http://tuplit.elasticbeanstalk.com"

#endif

#define REGISTER_URL                RESOURCE_URL @"/v1/users/"
#define LOGIN_URL                   RESOURCE_URL @"/oauth2/password/token"
#define FORGOT_PW_URL               RESOURCE_URL @"/v1/users/forgetPassword"
#define STATIC_CONTENT_URL          RESOURCE_URL @"/v1/contents/"
#define USER_DETAILS_URL            RESOURCE_URL @"/v1/users/%@"
#define MERCHANT_LISTING_URL        RESOURCE_URL @"/v1/merchants/"
#define CATEGORY_LISTING_URL        RESOURCE_URL @"/v1/categories/"
#define MERCHANT_DETAILS_URL        RESOURCE_URL @"/v1/merchants/%@"
#define CHECK_LOCATION_URL          RESOURCE_URL @"/v1/users/checklocation"
#define CHECK_BALANCE_URL           RESOURCE_URL @"/v1/users/checkbalance"
#define ORDERS_URL                  RESOURCE_URL @"/v1/orders/"
#define TRANSACTION_LISTING_URL     RESOURCE_URL @"/v1/users/transactions"
#define TRANSACTION_DETAIL_URL      RESOURCE_URL @"/v1/orders/%@"
#define COMMENT_DELETE_URL          RESOURCE_URL @"/v1/comments/%@"
#define COMMENT_LISTING_URL         RESOURCE_URL @"/v1/comments/"
#define SET_PIN_URL                 RESOURCE_URL @"/v1/users/setPIN"

/****** Notifications **************/

#define kUpdateUserData         @"kUpdateUserData"
#define kReloadUserProfile      @"kReloadUserProfile"    

@interface TuplitConstants : NSObject
NSString *LString(NSString* key);
+ (void)loadSliderHomePageWithAnimation:(BOOL)animated;
+ (NSString*) getDistance:(double) locationDistance;
+ (NSString*)calculateTimeDifference:(NSString *)timeStamp;
+ (NSMutableAttributedString*)getOpeningHrs:(NSString*)datestring isTimeFormat:(BOOL)isTime;
+ (NSMutableAttributedString*)getPriceRange:(NSString *)_priceString;
+ (NSString*)formatPhoneNumber:(NSString*)mobileNumber;
+ (NSNumberFormatter*) getCurrencyFormat;
+ (NSString*)getOrderDate:(NSString*)date;
+ (NSString*)getOrderDateTime:(NSString*)date;

+ (void) userLogout;

@end
