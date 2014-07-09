//
//  CartModel.m
//  Tuplit
//
//  Created by ev_mac5 on 17/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel

@synthesize merchantID,companyName,address,latitude,longitude,products,total,discountedTotal;

-(id) init {
    
    self = [super init];
    if (self) {
        
        merchantID = @"";
        companyName = @"";
        address = @"";
        products = [[NSMutableArray alloc] init];
        total = 0.0;
        discountedTotal = 0.0;
        latitude = 0.0;
        longitude = 0.0;
    }
    
    return self;
}

-(void) calculateTotalPrice {
    
    double totalPrice = 0;
    double totalDiscountPrice = 0;
    
    for (SpecialProductsModel *specProduct in APP_DELEGATE.cartModel.products) {
        
        totalPrice = totalPrice + ([specProduct.Price doubleValue] * [specProduct.quantity integerValue]);
        double finalPrice = specProduct.DiscountPrice.doubleValue;
        if (finalPrice == 0.0) {
            finalPrice = specProduct.Price.doubleValue;
        }
        totalDiscountPrice = totalDiscountPrice + (finalPrice * [specProduct.quantity integerValue]);
    }
    
    APP_DELEGATE.cartModel.discountedTotal = totalDiscountPrice;
    APP_DELEGATE.cartModel.total = totalPrice;
}

-(void) addItems:(SpecialProductsModel*) specialProductsModel {
    
    NSArray *tempArray = APP_DELEGATE.cartModel.products;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ProductId Matches[cd] %@",specialProductsModel.ProductId];
    NSArray *result = [tempArray filteredArrayUsingPredicate:pred];
    
    if(result.count > 0){
        specialProductsModel.quantity = [NSString stringWithFormat:@"%d",([specialProductsModel.quantity intValue] + 1)];
        
        for (SpecialProductsModel *specModel in APP_DELEGATE.cartModel.products) {
            
            if ([specModel.ProductId isEqualToString:specialProductsModel.ProductId]) {
                specModel.quantity = specialProductsModel.quantity;
            }
        }
    }
    else
    {
        specialProductsModel.quantity = @"1";
        [APP_DELEGATE.cartModel.products addObject:specialProductsModel];
    }
}

@end
