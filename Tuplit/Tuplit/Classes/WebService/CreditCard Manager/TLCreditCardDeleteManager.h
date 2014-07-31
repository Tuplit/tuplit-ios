//
//  TLCreditCardDeleteManager.h
//  Tuplit
//
//  Created by ev_mac11 on 09/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLCreditCardDeleteManager;
@protocol TLCreditCardDeleteManagerDelegate <NSObject>
@optional
- (void)creditCardDeleteManagerSuccess:(TLCreditCardDeleteManager *)creditCardDeleteManager;
- (void)creditCardDeleteManager:(TLCreditCardDeleteManager *)creditCardDeleteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)creditCardDeleteManagerFailed:(TLCreditCardDeleteManager *)creditCardDeleteManager;
@end

@interface TLCreditCardDeleteManager : NSObject

- (void)deleteCreditCard:(NSString*)cardID;
@property(nonatomic, unsafe_unretained) id <TLCreditCardDeleteManagerDelegate> delegate;

@end
