//
//  TLMerchantListingModel.h
//  Tuplit
//
//  Created by ev_mac5 on 28/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLMerchantListingModel : NSObject

@property (nonatomic, assign) int actionType;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, copy) NSString *Longitude;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *Start;
@property (nonatomic, copy) NSString *SearchKey;
@property (nonatomic, copy) NSString *DiscountTier;
@property (nonatomic, copy) NSString *Category;

@end
