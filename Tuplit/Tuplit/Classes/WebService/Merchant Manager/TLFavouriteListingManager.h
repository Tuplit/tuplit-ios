//
//  TLFavouriteListingManager.h
//  Tuplit
//
//  Created by ev_mac11 on 03/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLFavouriteListingManager;
@protocol TLFavouriteListingManagerDelegate <NSObject>
@optional
- (void)favouriteManagerSuccessfull:(TLFavouriteListingManager *) favouriteListManager withFavouriteList:(NSArray*)favouriteArray;
- (void)favouriteManager:(TLFavouriteListingManager *) favouriteListManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)favouriteManagerFailed:(TLFavouriteListingManager *) favouriteListManager;
@end

@interface TLFavouriteListingManager : NSObject


-(void) callService:(TLMerchantListingModel*) merchantListingModel;
@property(nonatomic, unsafe_unretained) id <TLFavouriteListingManagerDelegate> delegate;
@property(nonatomic, strong) TLMerchantListingModel* merchantListModel;
@property(nonatomic, strong) NSArray *favouriteArray;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;

-(void) cancelRequest;
@end
