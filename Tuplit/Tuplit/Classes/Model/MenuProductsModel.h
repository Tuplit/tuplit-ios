//
//  MenuProductsModel.h
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuProductsModel : NSObject

@property (nonatomic, copy) NSString * CategoryId;
@property (nonatomic, copy) NSString * CategoryName;

@property (nonatomic, copy) NSArray * Items; // Same as Discounted Model Use Model               "DiscountedProductsModel"

@end
