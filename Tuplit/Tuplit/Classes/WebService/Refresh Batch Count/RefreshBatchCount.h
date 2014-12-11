//
//  MGCUpadateBatchCount.h
//  TiltSDK
//
//  Created by ev_mac13 on 22/05/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RefreshBatchCount;

@protocol RefreshBatchCountDelegate <NSObject>
@optional

//- (void)updateBadgeCountManagerSuccessfull:(RefreshBatchCount *)updateBadgeCountManager message:(NSString*) message;
//- (void)updateBadgeCountManager:(RefreshBatchCount *)updateBadgeCountManager returnedWithErrorCode:(NSString *)errorCode errorMsg:(NSString *) errorMsg;
//- (void)updateBadgeCountManagerFailed:(RefreshBatchCount *)updateBadgeCountManager;

@end

@interface RefreshBatchCount : NSObject
{
   __weak id <RefreshBatchCountDelegate> delegate;
}

@property(nonatomic, weak) id <RefreshBatchCountDelegate> delegate;

-(void)updateBadgeCount;

@end
