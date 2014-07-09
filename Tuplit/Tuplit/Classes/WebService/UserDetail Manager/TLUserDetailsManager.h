//
//  TLUserDetailsManager.h
//  Tuplit
//
//  Created by ev_mac6 on 21/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserDetailModel.h"

@class TLUserDetailsManager;
@protocol TLUserDetailsManagerDelegate <NSObject>
- (void)userDetailManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_ withUserDetail:(UserDetailModel*)userDetail_;
- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager;
@end


@interface TLUserDetailsManager : NSObject {
    
    UserModel *userModel;
    UserDetailModel *userdetailModel;
}

@property(nonatomic, unsafe_unretained) id <TLUserDetailsManagerDelegate> delegate;

- (void)getUserDetailsWithUserID:(NSString*) userID;

@end
