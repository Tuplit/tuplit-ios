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

@interface TLUserDefaults : NSObject

+ (void)setCurrentUser:(UserModel*)user_;
+ (UserModel*)getCurrentUser;
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

@end
