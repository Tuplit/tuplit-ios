//
//  TLCurrentLocationManager.h
//  Tuplit
//
//  Created by ev_mac11 on 12/09/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLCurrentLocationManager;
@protocol TLCurrentLocationManagerDelegate <NSObject>
@optional
- (void)setCurrentLocationManagerSuccess:(TLCurrentLocationManager *)locationManager withSuccessMessage:(NSString *)message;
- (void)setCurrentLocationManager:(TLCurrentLocationManager *)locationManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
- (void)setCurrentLocationManagerFailed:(TLCurrentLocationManager *)locationManager;
@end

@interface TLCurrentLocationManager : NSObject
- (void)updateCurrentLocation :(NSDictionary*)queryParam;
@property(nonatomic, unsafe_unretained) id <TLCurrentLocationManagerDelegate> delegate;
@end
