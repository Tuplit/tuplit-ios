//
//  TLOrderPaymentManager.h
//  Tuplit
//
//  Created by ev_mac11 on 08/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLOrderPaymentManager;
@protocol TLOrderPaymentManagerDelegate <NSObject>
@optional
- (void)orderPaymentManagerSuccessfull:(TLOrderPaymentManager *)orderPaymentManager withStatus:(NSString*)topupStatus;
- (void)orderPaymentManager:(TLOrderPaymentManager *)orderPaymentManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)orderPaymentManagerFailed:(TLOrderPaymentManager *)orderPaymentManager;
@end

@interface TLOrderPaymentManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLOrderPaymentManagerDelegate> delegate;

@end
