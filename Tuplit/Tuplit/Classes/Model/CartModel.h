//
//  CartModel.h
//  Tuplit
//
//  Created by ev_mac5 on 17/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

@property(nonatomic,strong) NSString *merchantID;
@property(nonatomic,strong) NSString *companyName;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;
@property(nonatomic,strong) NSMutableArray *products;
@property(nonatomic,assign) double total;
@property(nonatomic,assign) double vat;
@property(nonatomic,assign) double subtotal;
@property(nonatomic,assign) double discountedTotal;
@property(nonatomic,assign) int productCount;

- (void) calculateTotalPrice;
-(void)calculateSubtotalPrice;
-(void)calculateVatPrice;
- (void) addItems:(SpecialProductsModel*) specialProductsModel;

@end
