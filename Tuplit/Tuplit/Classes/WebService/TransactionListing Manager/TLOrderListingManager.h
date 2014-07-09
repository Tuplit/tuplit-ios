//
//  TLOrderListingManager.h
//  Tuplit
//
//  Created by ev_mac11 on 26/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"
#import "OrderProductModel.h"

@class TLOrderListingManager;
@protocol TLOrderListingManagerDelegate <NSObject>

@optional
- (void)orderDetailsManagerSuccessful:(TLOrderListingManager *)orderDetailsManager withorderDetails:(OrderDetailModel*) orderDetailModel;
- (void)orderDetailsManager:(TLOrderListingManager *)orderDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)orderDetailsManagerFailed:(TLOrderListingManager *)orderDetailsManager;
@end


@interface TLOrderListingManager : NSObject
-(void) callService:(NSString*) orderID;
@property(nonatomic, unsafe_unretained) id <TLOrderListingManagerDelegate> delegate;
@property(nonatomic, strong) OrderDetailModel * orderDetailsModel;
@end
