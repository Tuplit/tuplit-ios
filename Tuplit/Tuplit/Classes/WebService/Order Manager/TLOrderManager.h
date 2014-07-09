//
//  TLOrderManager.h
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLOrderManager;
@protocol TLOrderManagerDelegate <NSObject>
@optional
- (void)processOrdersManagerSuccessfull:(TLOrderManager *)processOrdersManager withorderStatus:(NSString*)orderStatus orderId:(NSString*)orderID;
- (void)processOrdersManager:(TLOrderManager *)processOrdersManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)processOrdersManagerFailed:(TLOrderManager *)processOrdersManager;
@end
@interface TLOrderManager : NSObject

-(void)processOrders:(NSDictionary*)dict;
@property(nonatomic, unsafe_unretained) id <TLOrderManagerDelegate> delegate;

@end
