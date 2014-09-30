//
//  MerchantModel.h
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantModel : NSObject

@property (nonatomic, copy) NSString * MerchantID;
@property (nonatomic, copy) NSString * Icon;
@property (nonatomic, copy) NSString * Image;
@property (nonatomic, copy) NSString * DiscountTier;
@property (nonatomic, copy) NSString * CompanyName;
@property (nonatomic, copy) NSString * ShortDescription;
@property (nonatomic, copy) NSString * Address;
@property (nonatomic, copy) NSString * ItemsSold;
@property (nonatomic, copy) NSString * Latitude;
@property (nonatomic, copy) NSString * Longitude;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * IsSpecial;
@property (nonatomic, copy) NSString * IsGoldenTag;
@property (nonatomic, copy) NSString * NewTag;
@property (nonatomic, copy) NSString * Category;
@property (nonatomic, copy) NSString * TotalUsersShopped;
@property (nonatomic, copy) NSString * TagType;


@end
