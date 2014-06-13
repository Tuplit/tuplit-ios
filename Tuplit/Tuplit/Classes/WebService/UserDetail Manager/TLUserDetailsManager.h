//
//  TLUserDetailsManager.h
//  Tuplit
//
//  Created by ev_mac6 on 21/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLUserDetailsManager;
@protocol TLUserDetailsManagerDelegate <NSObject>
@optional
- (void)userDetailsManagerSuccess:(TLUserDetailsManager *)userDetailsManager withUser:(UserModel*)user_;
- (void)userDetailsManager:(TLUserDetailsManager *)userDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)userDetailsManagerFailed:(TLUserDetailsManager *)userDetailsManager;
@end


@interface TLUserDetailsManager : NSObject
- (void)getUserDetails;
@property(nonatomic, unsafe_unretained) id <TLUserDetailsManagerDelegate> delegate;
@end
