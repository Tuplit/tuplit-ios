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



/******** General ********/

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define DATE_PICKER_HEIGHT 250


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
#define GOOGLE_CLIENT_ID      @"67542159633-3t664mkheusv6r5fp4qjdq8n241v3rbf.apps.googleusercontent.com";
#define FACEBOOK_APP_ID       @"1516322561916139" // @"664739730282382"       //"1443093035941769" // 664739730282382

//client ID : 1516322561916139

#define CLIENTID              @"8acc207693494259fd435dd54915fe9b6465d3a7"
#define CLIENT_SECRET_ID      @"b915d9fed580e700b8831be8c8ecd0cb205fce57"

/***** CREDIT CARD NUMBER USING SCAN.IO *****/

#define CardIOAppToken      @"f689bfbe34ce4f938c7a3dfbdb8b0dd0"

/******** NETWORK TEST PROCEDURE ********/
#define NETWORK_TEST_PROCEDURE          if (![NetworkConnectivity hasConnectivity]) { [APP_DELEGATE showNoConnectivityAlertAndQuit:NO]; return; }

#define DISMISS_KEYBOARD [self.view endEditing:YES]

///********* LOG HANDLING ***************/

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#if TARGET_IPHONE_SIMULATOR
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif   
#endif

/******** WEB SERVICE END-POINTS ********/

#if DEBUG

   #define RESOURCE_URL                @"http://172.21.4.104/tuplit"

#else

//    #define RESOURCE_URL                @"http://tuplit.elasticbeanstalk.com"
   #define RESOURCE_URL                @"https://api.tuplit.com"

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
#define ADD_FAVOURITE_URL           RESOURCE_URL @"/v1/merchants/favorites"
#define VERIFY_PIN_URL              RESOURCE_URL @"/v1/users/verifyPin"
#define ADD_CREDITCARD_URL          RESOURCE_URL @"/v1/cards/"
#define DELETE_CREDITCARD_URL       RESOURCE_URL @"/v1/cards/%@"
#define ORDER_PAYMENT_URL           RESOURCE_URL @"/v1/orders/payment"
#define TOPUP_URL                   RESOURCE_URL @"/v1/cards/topup"
#define TRANSFER_URL                RESOURCE_URL @"/v1/users/transfer"
#define FAVOURITE_LIST_URL          RESOURCE_URL @"/v1/users/favorites"
#define FRIENDS_LIST_URL            RESOURCE_URL @"/v1/users/friends"
#define CHECK_FRIENDS_URL           RESOURCE_URL @"/v1/users/checkfriends"
#define INVITE_FRIENDS_URL          RESOURCE_URL @"/v1/invites/"
#define SETTINGS_URL                RESOURCE_URL @"/v1/users/settings"
#define CURRENT_LOCATION_URL        RESOURCE_URL @"/v1/users/currentLocation"
#define ADD_FRIEND_URL              RESOURCE_URL @"/v1/users/%@/friend"
#define REFRESH_BADGE_COUNT_URL     RESOURCE_URL @"/v1/notifications/badgecount"

/****** Notifications **************/

#define kUpdateUserData         @"kUpdateUserData"
#define kReloadUserProfile      @"kReloadUserProfile"  
#define kCreditCardAdded        @"kCreditCardAdded"
#define kFBWelcomeScreen        @"kFBWelcomeScreen"
#define kWelcomeScreenSlideShowStarter @"kWelcomeScreenSlideShowStarter"
#define kFBSignupScreen         @"kFBSignupScreen"
#define kUpdateRecentOrders     @"kUpdateRecentOrders"
#define kUpdateFriendsActivity  @"kUpdateFriendsActivity"
#define kStaticContentRetrived  @"kStaticContentRetrived"
#define kUpdateUserProfile      @"kUpdateUserProfile"
#define kUpdateUserProfileInBackground @"kUpdateUserProfileInBackground"
#define kIsFavouriteChanged     @"kIsFavouriteChanged"

/****** Format Filters **************/
#define CARDAMEX            @"#### ###### #####"
#define CARDDEFAULT         @"#### #### #### ####"
#define CARDNORMAL          @"################"
#define DATEFORMAT          @"##/##"
#define DATENORMAL          @"####"
#define CVVFORMAT           @"###"
#define PHONE_NUM_FORMAT    @"(###)###-####"

#define CAEDAMEXEXP      @"^3[47][0-9]{5,}$"

/****** Customer Support ************/
#define CUSTOMER_SUPPORT_EMAIL @"help@tuplit.com"
#define CUSTOMER_SUPPORT_PNUMBER @"+1 234 567 8"

#define CALL_OUT_POS CGPointMake(-2,-69)


@interface TuplitConstants : NSObject
NSString *LString(NSString* key);
+ (void)loadSliderHomePageWithAnimation:(BOOL)animated;
+ (NSString*) getDistance:(double) locationDistance;
+ (NSString*)calculateTimeDifference:(NSString *)timeStamp;
+(NSArray*)getOpeningHrs:(NSArray*)openHrsArray;
//+(NSMutableAttributedString*)getOpeningHrs:(NSString*)datestring isTimeFormat:(BOOL)isTime;
+ (NSMutableAttributedString*)getPriceRange:(NSString *)_priceString;
+ (NSString*)formatPhoneNumber:(NSString*)mobileNumber;
+ (NSNumberFormatter*) getCurrencyFormat;
+ (NSString*)getOrderDate:(NSString*)date;
+ (NSString*)getOrderDateTime:(NSString*)date;
+ (NSMutableString*)filteredPhoneStringFromString:(NSString*)string withFilter:(NSString*)filter;
+ (void) userLogout;
+(NSString*)dobFormattedDate:(NSString*)datefromServer;
+(NSString*)facebookFormattedDate:(NSString*)datefromServer;
+ (void)zoomToFitMapAnnotations:(MKMapView *)mapView;
+(BOOL) isMerchantClosed:(NSArray*) openHrsArray;
+(void)openMyProfile;
+(void)openMerchantVC;

@end
