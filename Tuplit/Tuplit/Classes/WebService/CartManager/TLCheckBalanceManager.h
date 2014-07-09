//
//  TLCheckBalanceManager.h
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentModel.h"

@class  TLCheckBalanceManager;

@protocol TLCheckBalanceManagerDelegate <NSObject>
@optional
- (void)checkBalanceManagerSuccessfull:(TLCheckBalanceManager *)checkBalanceManager paymentModel:(PaymentModel *)paymentModel;
- (void)checkBalanceManager:(TLCheckBalanceManager *)checkBalanceManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)checkBalanceManagerFailed:(TLCheckBalanceManager *)checkBalanceManager;
@end

@interface TLCheckBalanceManager : NSObject{
    
}

@property(nonatomic, unsafe_unretained) id <TLCheckBalanceManagerDelegate> delegate;

-(void)getCurrentBalanceWithPaymentAmount:(NSString*)paymentAmount;

@end
