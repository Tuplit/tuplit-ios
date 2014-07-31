//
//  TLAddCreditCardManager.h
//  Tuplit
//
//  Created by ev_mac11 on 07/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLAddCreditCardManager;
@protocol TLAddCreditCardManagerDelegate <NSObject>
@optional
- (void)addCreditCardManagerSuccessfull:(TLAddCreditCardManager *)addCreditCardManager withStatus:(NSString*)creditCardStatus;
- (void)addCreditCardManager:(TLAddCreditCardManager *)addCreditCardManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)addCreditCardManagerFailed:(TLAddCreditCardManager *)addCreditCardManager;
@end

@interface TLAddCreditCardManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLAddCreditCardManagerDelegate> delegate;

@end
