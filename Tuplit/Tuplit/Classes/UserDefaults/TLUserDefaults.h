//
//  TuplitUserDefaults.h
//  Tuplit
//
//  Created by ev_mac6 on 23/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface TLUserDefaults : NSObject

+ (void)setCurrentUser:(UserModel*)user_;
+ (UserModel*)getCurrentUser;
+ (void)setGuestUser:(UserModel*)user_;
+ (UserModel*)getGuestUser;
+ (void)setIsGuestUser:(BOOL)isSkipped_;
+ (BOOL)isGuestUser;
+ (void)setIsTutorialSkipped:(BOOL)isSkipped_;
+ (BOOL)isTutorialSkipped;

@end
