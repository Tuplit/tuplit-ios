//
//  TLVerifyPinManager.h
//  Tuplit
//
//  Created by ev_mac11 on 05/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLVerifyPinManager;
@protocol TLVerifyPinManagerDelegate <NSObject>
@optional
- (void)verifyPinManagerSuccessWithValue:(NSString*)pinType Withnotification:(NSString *)notification;
- (void)verifyPinManager:(TLVerifyPinManager *)pinManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
- (void)verifyPinManagerFailed:(TLVerifyPinManager *)pinManager;
@end

@interface TLVerifyPinManager : NSObject

- (void)verifyPinCode :(NSString*)pincode;
@property(nonatomic, unsafe_unretained) id <TLVerifyPinManagerDelegate> delegate;
@end
