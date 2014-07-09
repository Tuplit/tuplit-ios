//
//  RecentActivityModel.h
//  Tuplit
//
//  Created by ev_mac11 on 24/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentActivityModel : NSObject

@property (nonatomic, copy)NSString *OrderId;
@property (nonatomic, copy)NSString *MerchantID;
@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, copy)NSString *Location;
@property (nonatomic, copy)NSString *Icon;
@property (nonatomic, copy)NSString *TotalItems;
@property (nonatomic, copy)NSString *TotalPrice;
@property (nonatomic, copy)NSString *OrderDate;
@property (nonatomic, copy)NSString *MerchantIcon;

@end
