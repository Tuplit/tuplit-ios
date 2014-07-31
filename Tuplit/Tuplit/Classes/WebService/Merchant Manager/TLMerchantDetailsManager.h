//
//  TLMerchantDetailsManager.h
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantsDetailsModel.h"
#import "FriendsListModel.h"
#import "OpeningHoursModel.h"
#import "CommentsModel.h"
#import "ProductListModel.h"
#import "SpecialProductsModel.h"
#import "MenuProductsModel.h"
#import "TLMerchantListingModel.h"

@class TLMerchantDetailsManager;
@protocol TLMerchantDetailsManagerDelegate <NSObject>

@optional
- (void)merchantDetailsManagerSuccessful:(TLMerchantDetailsManager *)merchantDetailsManager withMerchantDetails:(MerchantsDetailsModel*) merchantDetailModel;
- (void)merchantDetailsManager:(TLMerchantDetailsManager *)merchantDetailsManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)merchantDetailsManagerFailed:(TLMerchantDetailsManager *)merchantDetailsManager;
@end

@interface TLMerchantDetailsManager : NSObject

-(void) callService:(TLMerchantListingModel*) merchantListingModel;

@property(nonatomic, unsafe_unretained) id <TLMerchantDetailsManagerDelegate> delegate;
@property(nonatomic, strong) MerchantsDetailsModel * merchantDetailsModel;
@property(nonatomic, assign) BOOL isAllowCartEnabled;

@end
