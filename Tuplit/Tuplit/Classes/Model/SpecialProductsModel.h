//
//  SpecialsModel.h
//  Tuplit
//
//  Created by ev_mac11 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialProductsModel : NSObject

@property (nonatomic, copy) NSString * ProductId;
@property (nonatomic, copy) NSString * ItemName;
@property (nonatomic, copy) NSString * Photo;
@property (nonatomic, copy) NSString * Price;
@property (nonatomic, copy) NSString * DiscountPrice;
@property (nonatomic, copy) NSString * DiscountTier;
@property (nonatomic, copy) NSString * DiscountApplied;
@property (nonatomic, copy) NSString * Status;
@property (nonatomic, copy) NSString * Ordering;

@property (nonatomic, copy) NSString * quantity;

@end
