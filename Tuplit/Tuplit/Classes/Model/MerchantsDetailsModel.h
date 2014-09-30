//
//  MerchantsDetailsModel.h
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantsDetailsModel : NSObject

@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * MerchantId;
@property (nonatomic, copy) NSString * FirstName;
@property (nonatomic, copy) NSString * LastName;
@property (nonatomic, copy) NSString * Email;

@property (nonatomic, copy) NSString * CompanyName;
@property (nonatomic, copy) NSString * Address;
@property (nonatomic, copy) NSString * Location;
@property (nonatomic, copy) NSString * Latitude;
@property (nonatomic, copy) NSString * Longitude;

@property (nonatomic, copy) NSString * PhoneNumber;
@property (nonatomic, copy) NSString * WebsiteUrl;
@property (nonatomic, copy) NSString * Icon;
@property (nonatomic, copy) NSString * Image;
@property (nonatomic, copy) NSString * Description;

@property (nonatomic, copy) NSString * ShortDescription;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * DiscountTier;
@property (nonatomic, copy) NSString * DiscountType;
@property (nonatomic, copy) NSString * DiscountProductId;

@property (nonatomic, copy) NSString * SpecialIcon;
@property (nonatomic, copy) NSString * ItemsSold;
@property (nonatomic, copy) NSArray * OpeningHours;
@property (nonatomic, copy) NSString * PriceRange;
@property (nonatomic, copy) NSString * SpecialsSold;
@property (nonatomic, copy) NSString * CustomersCount;
@property (nonatomic, copy) NSString * TagType;

@property (nonatomic, copy) NSString * AlreadyFavourited;
@property (nonatomic, copy) NSString * Category;
@property (nonatomic, copy) NSString * OrderCount;
@property (nonatomic, copy) NSString * OrderedFriendsCount;
@property (nonatomic, copy) NSString * IsGoldenTag;

@property (nonatomic, copy) NSArray * OrderedFriendsList;
@property (nonatomic, copy) NSArray * Comments;
@property (nonatomic, copy) NSArray * slideshow;

@property (nonatomic, copy) NSArray * ProductList;

@property (nonatomic, copy) NSArray * SpecialProducts;
@property (nonatomic, copy) NSArray * DiscountProducts;
@property (nonatomic, copy) NSArray * MenuProducts;     //Contains Items Array.
@property (nonatomic, copy) NSArray * CategoryList;

@end
