//
//  TLMerchantListingManager.h
//  Tuplit
//
//  Created by ev_mac5 on 28/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLMerchantListingModel.h"

@class TLMerchantListingManager;
@protocol TLMerchantListingManagerDelegate <NSObject>
@optional
- (void)merchantListingManager:(TLMerchantListingManager *)merchantListingManager withMerchantList:(NSArray*) merchantArray;
- (void)merchantListingManager:(TLMerchantListingManager *)merchantListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)merchantListingManager:(TLMerchantListingManager *)merchantListingManager;
@end

@interface TLMerchantListingManager : NSObject

-(void) callService:(TLMerchantListingModel*) merchantListingModel;

@property(nonatomic, unsafe_unretained) id <TLMerchantListingManagerDelegate> delegate;
@property(nonatomic, copy) TLMerchantListingModel* merchantListModel;
@property(nonatomic, copy) NSArray *merchantArray;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;

-(void) cancelRequest;

@end
