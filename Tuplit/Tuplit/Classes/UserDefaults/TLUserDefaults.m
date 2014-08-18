//
//  TuplitUserDefaults.m
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLUserDefaults.h"
#define UserDefaults   [NSUserDefaults standardUserDefaults]
#define kUser @"User"
#define kGuestUser @"GuestUser"
#define kIsSkipped @"IsSkipped"
#define kIsTutoriakSkipped @"IsTutoriakSkipped"
#define kCart @"kCart"
#define kAccessToken @"kAccessToken"
#define kDeviceToken @"kDeviceToken"
#define kIsCommentPromtOpen @"kIsCommentPromtOpen"
#define kCommentDetails @"kCommentDetails"
#define kItunesURL @"kItunesURL"
#define kISPINCodeDisabled @"kISPINCodeDisabled"


@implementation TLUserDefaults

+ (void)setCurrentUser:(UserModel*)user_ {

    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user_];
    [UserDefaults setObject:encodedObject forKey:kUser];
    [UserDefaults synchronize];
}

+ (UserModel*)getCurrentUser {
    NSData *objectToDecode = [UserDefaults valueForKey:kUser];
    UserModel *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:objectToDecode];
    return decodedObject;
}

+ (void)setIsGuestUser:(BOOL)isSkipped_ {
    
    [UserDefaults setBool:isSkipped_ forKey:kIsSkipped];
    [UserDefaults synchronize];
}

+ (BOOL)isGuestUser {
    
    return [UserDefaults boolForKey:kIsSkipped];
}

+ (void)setIsTutorialSkipped:(BOOL)isSkipped_ {
    
    [UserDefaults setBool:isSkipped_ forKey:kIsTutoriakSkipped];
    [UserDefaults synchronize];
}

+ (BOOL)isTutorialSkipped {
    
    return [UserDefaults boolForKey:kIsTutoriakSkipped];
}

+ (void)setCart:(CartModel*) cartModel {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:cartModel];
    [UserDefaults setObject:encodedObject forKey:kCart];
    [UserDefaults synchronize];
}

+ (CartModel*) getCart {
    
    NSData *objectToDecode = [UserDefaults valueForKey:kCart];
    CartModel *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:objectToDecode];
    return decodedObject;
}

+ (void)setAccessToken:(NSString*) accessToken {
    
    [UserDefaults setObject:accessToken forKey:kAccessToken];
    [UserDefaults synchronize];
}

+ (NSString*)getAccessToken {
    
    return [UserDefaults objectForKey:kAccessToken];
}
+ (void)setDeviceToken:(NSString *)deviceToken {
	
    [UserDefaults setValue:deviceToken forKey:kDeviceToken];
    [UserDefaults synchronize];
}

+ (NSString *)getDeviceToken {
	
	return [UserDefaults valueForKey:kDeviceToken];
}

+ (void)setIsCommentPromptOpen:(BOOL)isOpen
{
    [UserDefaults setBool:isOpen forKey:kIsCommentPromtOpen];
    [UserDefaults synchronize];
}
+ (BOOL)isCommentPromptOpen
{
    return [UserDefaults boolForKey:kIsCommentPromtOpen];
}

+ (void)setCommentDetails:(OrderDetailModel*)commentDetails
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:commentDetails];
    [UserDefaults setValue:encodedObject forKey:kCommentDetails];
    [UserDefaults synchronize];
}
+ (OrderDetailModel*)getCommentDetails
{
    NSData *objectToDecode = [UserDefaults valueForKey:kCommentDetails];
    OrderDetailModel *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:objectToDecode];
    return decodedObject;
}

+ (void)setItunesURL:(NSString*) link
{
    [UserDefaults setValue:link forKey:kItunesURL];
    [UserDefaults synchronize];
}

+ (NSString*)getItunesURL
{
    return ([UserDefaults valueForKey:kItunesURL]==nil)?@"<Appstore url>":[UserDefaults valueForKey:kItunesURL];
}

+ (void)setIsPINCodeEnabled:(BOOL)isEnabled
{
    [UserDefaults setBool:isEnabled forKey:kISPINCodeDisabled];
    [UserDefaults synchronize];
}
+ (BOOL)isPINCodeEnabled
{
    return [UserDefaults boolForKey:kISPINCodeDisabled];
}
@end
