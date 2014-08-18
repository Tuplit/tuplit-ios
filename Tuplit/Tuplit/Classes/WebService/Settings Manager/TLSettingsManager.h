//
//  TLSettingsManager.h
//  Tuplit
//
//  Created by ev_mac11 on 01/08/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLSettingsManager;

@protocol TLSettingsManagerDelegate <NSObject>
@optional
- (void)settingsManager:(TLSettingsManager *)settingsManager updateSuccessfullWithUserSettings:(NSString *)successmessage;
- (void)settingsManagererror:(TLSettingsManager *)settingsManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
- (void)settingsManagerFailed:(TLSettingsManager *)settingsManager;
@end

@interface TLSettingsManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLSettingsManagerDelegate> delegate;
@end
