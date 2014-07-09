//
//  OrderProductModel.h
//  Tuplit
//
//  Created by ev_mac11 on 26/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProductModel : NSObject
@property (nonatomic, copy)NSString *ProductID;
@property (nonatomic, copy)NSString *ItemName;
@property (nonatomic, copy)NSString *Photo;
@property (nonatomic, copy)NSString *ProductsQuantity;
@property (nonatomic, copy)NSString *ProductsCost;
@property (nonatomic, copy)NSString *DiscountPrice;
@property (nonatomic, copy)NSString *TotalPrice;
@end
