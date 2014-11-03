//
//  OrderDetailModel.h
//  Tuplit
//
//  Created by ev_mac11 on 26/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic, copy)NSString *OrderId;
@property (nonatomic, copy)NSString *CartId;
@property (nonatomic, copy)NSString *UserId;
@property (nonatomic, copy)NSString *MerchantId;
@property (nonatomic, copy)NSString *TotalPrice;
@property (nonatomic, copy)NSString *TransactionId;
@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, copy)NSString *Address;
@property (nonatomic, copy)NSString *Location;
@property (nonatomic, copy)NSString *Photo;
@property (nonatomic, copy)NSString *FirstName;
@property (nonatomic, copy)NSString *LastName;
@property (nonatomic, copy)NSString *Email;
@property (nonatomic, copy)NSString *OrderDate;
@property (nonatomic, copy)NSString *OrderDoneBy;
@property (nonatomic, copy)NSString *UniqueId;
@property (nonatomic, copy)NSString *SubTotal;
@property (nonatomic, copy)NSString *VAT;
@property (nonatomic, copy)NSArray *Products;
@end
