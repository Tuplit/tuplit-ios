//
//  TLTopupManager.h
//  Tuplit
//
//  Created by ev_mac11 on 08/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLTopupManager;
@protocol TLTopupManagerDelegate <NSObject>
@optional
- (void)topupManagerSuccessfull:(TLTopupManager *)topupManager withStatus:(NSString*)topupStatus;
- (void)topupManager:(TLTopupManager *)topupManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)topupManagerFailed:(TLTopupManager *)topupManager;
@end

@interface TLTopupManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLTopupManagerDelegate> delegate;

@end
