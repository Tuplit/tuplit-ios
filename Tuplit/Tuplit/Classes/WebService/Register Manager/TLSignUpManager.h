//
//  TLSignUpManager.h
//  Tuplit
//
//  Created by ev_mac6 on 28/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@class TLSignUpManager;
@protocol TLSignUpManagerDelegate <NSObject>
@optional
- (void)signUpManager:(TLSignUpManager *)signUpManager registerSuccessfullWithUser:(UserModel *)user isAlreadyRegistered:(BOOL)isAlreadyRegistered;
- (void)signUpManager:(TLSignUpManager *)signUpManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
- (void)signUpManagerFailed:(TLSignUpManager *)signUpManager;
@end

@interface TLSignUpManager : NSObject
- (void)registerUser;
@property(nonatomic, unsafe_unretained) id <TLSignUpManagerDelegate> delegate;
@property(nonatomic, unsafe_unretained) UserModel *user;
@end
