//
//  TLEditUpdateManager.h
//  Tuplit
//
//  Created by ev_mac11 on 02/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLEditUpdateManager;

@protocol TLEditUpdateManagerDelegate <NSObject>
@optional
- (void)editUpManager:(TLEditUpdateManager *)editUpManager updateSuccessfullWithUser:(UserModel *)user;
- (void)editUpManager:(TLEditUpdateManager *)editUpManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
- (void)editUpManagerFailed:(TLEditUpdateManager *)signUpManager;
@end

@interface TLEditUpdateManager : NSObject

- (void)updateUser;

@property(nonatomic, unsafe_unretained) id <TLEditUpdateManagerDelegate> delegate;
@property(nonatomic, unsafe_unretained) UserModel *user;

@end
