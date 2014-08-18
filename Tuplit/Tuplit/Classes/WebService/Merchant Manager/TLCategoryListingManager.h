//
//  TLMerchantListingManager.h
//  Tuplit
//
//  Created by ev_mac5 on 28/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLMerchantListingModel.h"

@class TLCategoryListingManager;
@protocol TLCategoryListingManagerDelegate <NSObject>
@optional
- (void)categoryListingManager:(TLCategoryListingManager *)categoryListingManager withCategoryList:(NSArray*) categoryArray;
- (void)categoryListingManager:(TLCategoryListingManager *)categoryListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)categoryListingManagerOnFailed:(TLCategoryListingManager *)categoryListingManager;
@end

@interface TLCategoryListingManager : NSObject

-(void) callService;

@property(nonatomic, unsafe_unretained) id <TLCategoryListingManagerDelegate> delegate;
@property(nonatomic, copy) NSArray *categoryArray;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;

-(void) cancelRequest;

@end
