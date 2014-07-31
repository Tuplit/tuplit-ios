//
//  TLCreditCardListingManager.h
//  Tuplit
//
//  Created by ev_mac11 on 07/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLCreditCardListingManager;
@protocol TLCreditCardListingManagerDelegate <NSObject>
@optional
- (void)creditCardListManagerSuccessfull:(TLCreditCardListingManager *)creditCardListManager withCreditCardList:(NSArray*)creditCardList;
- (void)creditCardListManager:(TLCreditCardListingManager *)creditCardListManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)creditCardListanagerFailed:(TLCreditCardListingManager *)creditCardListManager;
@end

@interface TLCreditCardListingManager : NSObject

-(void) callService:(int)start;
@property(nonatomic, unsafe_unretained) id <TLCreditCardListingManagerDelegate> delegate;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;
@end
