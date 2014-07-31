//
//  TLTransferManager.h
//  Tuplit
//
//  Created by ev_mac11 on 15/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLTransferManager;
@protocol TLTransferDelegate <NSObject>
@optional
- (void)transferManagerSuccessfull:(TLTransferManager *)transferManager withStatus:(NSString*)transferStatus;
- (void)transferManager:(TLTransferManager *)transferManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)transferManagerFailed:(TLTransferManager *)transferManager;
@end

@interface TLTransferManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLTransferDelegate> delegate;

@end
