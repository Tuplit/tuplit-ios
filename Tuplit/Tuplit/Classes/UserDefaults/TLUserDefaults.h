//
//  TuplitUserDefaults.h
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CartModel.h"
#import "OrderDetailModel.h"

@interface TLUserDefaults : NSObject

+ (void)setCurrentUser:(UserModel*)user_;
+ (UserModel*)getCurrentUser;

+ (void)setRememberMeDetails:(NSDictionary*)dict;
+ (NSDictionary*)getRememberedDict;

+ (void)setIsRememberMe:(BOOL)isRememberMe;
+ (BOOL)IsRememberMe;

+ (void)setIsGuestUser:(BOOL)isSkipped_;
+ (BOOL)isGuestUser;

+ (void)setIsTutorialSkipped:(BOOL)isSkipped_;
+ (BOOL)isTutorialSkipped;

+ (void)setCart:(CartModel*) cartModel;
+ (CartModel*) getCart;

+ (void)setAccessToken:(NSString*) accessToken;
+ (NSString*)getAccessToken;

+ (void)setDeviceToken:(NSString *)deviceToken;
+ (NSString *)getDeviceToken;

+ (void)setIsCommentPromptOpen:(BOOL)isOpen;
+ (BOOL)isCommentPromptOpen;

+ (void)setCommentDetails:(OrderDetailModel*)commentDetails;
+ (OrderDetailModel*)getCommentDetails;

+ (void)setItunesURL:(NSString*) link;
+ (NSString*)getItunesURL;

+ (void)setIsPINCodeEnabled:(BOOL)isEnabled;
+ (BOOL)isPINCodeEnabled;

+ (void)setInviteMsg:(NSString*)inviteMsg;
+ (NSString *)inviteMsg;

@end
