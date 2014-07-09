//
//  TLSetPinManager.h
//  Tuplit
//
//  Created by ev_mac11 on 02/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TLSetPinManager;
@protocol TLSetPinManagerDelegate <NSObject>
@optional
- (void)setPinManagerSuccess:(TLSetPinManager *)pinManager updateSuccessfullWithUser:(UserModel *)user;
- (void)setPinManager:(TLSetPinManager *)pinManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
- (void)setPinManagerFailed:(TLSetPinManager *)pinManager;
@end
@interface TLSetPinManager : NSObject

- (void)updatePinCode :(NSString*)pincode;
@property(nonatomic, unsafe_unretained) id <TLSetPinManagerDelegate> delegate;

@end
