//
//  PaymentModel.h
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

@property (nonatomic, copy) NSString * UserId;
@property (nonatomic, copy) NSString * PaymentAmount;
@property (nonatomic, copy) NSString * CurrentBalance;
@property (nonatomic, copy) NSString * AllowPayment;

@end
