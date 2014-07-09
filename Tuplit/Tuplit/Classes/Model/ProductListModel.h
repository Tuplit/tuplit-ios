//
//  ProductListModel.h
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductListModel : NSObject

// Common Property for Special,Discount and Menu Products
@property (nonatomic, copy) NSArray * SpecialProducts;
@property (nonatomic, copy) NSArray * DiscountProducts;
@property (nonatomic, copy) NSArray * MenuProducts;


// Property For Menu Products


@end
