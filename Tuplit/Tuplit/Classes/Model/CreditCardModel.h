//
//  CreditCardModel.h
//  Tuplit
//
//  Created by ev_mac11 on 07/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCardModel : NSObject

@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *CardNumber;
@property (nonatomic, copy)NSString *CardType;
@property (nonatomic, copy)NSString *ExpirationDate;
@property (nonatomic, copy)NSString *Currency;
@property (nonatomic, copy)NSString *Image;

@end
