//
//  TLPayWithUserLocationManager.h
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  TLCheckLocationManager;

@protocol TLCheckLocationManagerDelegate <NSObject>
@optional
- (void)checkLocationManagerSuccessfull:(TLCheckLocationManager *)checkLocationManager allowCart:(int)allowCart;
- (void)checkLocationManager:(TLCheckLocationManager *)checkLocationManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)checkLocationManagerFailed:(TLCheckLocationManager *)checkLocationManager;
@end

@interface TLCheckLocationManager : NSObject{
    
}

@property(nonatomic, unsafe_unretained) id <TLCheckLocationManagerDelegate> delegate;

-(void)callCheckLocationWithMerchantId:(NSString*)merchantId latitude:(NSString*)latitude longitude:(NSString*)longitude;

@end
