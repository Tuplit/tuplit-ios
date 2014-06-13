//
//  TLForgotPasswordManager.h
//  Tuplit
//
//  Created by ev_mac1 on 13/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLForgotPasswordManager;
@protocol TLForgotPasswordManagerDelegate <NSObject>
@optional
- (void)forgotPasswordManagerSuccess:(TLForgotPasswordManager *)forgotPasswordManager;
- (void)forgotPasswordManager:(TLForgotPasswordManager *)forgotPasswordManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)forgotPasswordManagerFailed:(TLForgotPasswordManager *)forgotPasswordManager;
@end


@interface TLForgotPasswordManager : NSObject
- (void)forgotPasswordForEmail:(NSString*)email;
@property(nonatomic, unsafe_unretained) id <TLForgotPasswordManagerDelegate> delegate;
@end
