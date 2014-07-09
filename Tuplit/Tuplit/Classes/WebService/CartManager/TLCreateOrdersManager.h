//
//  TLCreateOrdersManager.h
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  TLCreateOrdersManager;

@protocol TLCreateOrdersManagerDelegate <NSObject>
@optional
- (void)createOrdersManagerSuccessfull:(TLCreateOrdersManager *)createOrdersManager orderId:(NSString*)orderID transactionID:(NSString*) transID;
- (void)createOrdersManager:(TLCreateOrdersManager *)createOrdersManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)createOrdersManagerFailed:(TLCreateOrdersManager *)createOrdersManager;
@end

@interface TLCreateOrdersManager : NSObject{
    
}

@property(nonatomic, unsafe_unretained) id <TLCreateOrdersManagerDelegate> delegate;

-(void)addOrders:(NSDictionary*)dict;

@end

