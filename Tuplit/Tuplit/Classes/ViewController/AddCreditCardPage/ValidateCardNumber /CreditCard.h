//
//  CreditCard.h
//  CreditCardValidation
//
//  Created by Miguel Cohnen on 5/31/13.
//  Copyright (c) 2013 Miguel Cohnen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *expirationMonthYear;
//@property (nonatomic, copy) NSString *expirationYear;
@property (nonatomic, copy) NSString *ccv;
//@property (nonatomic, copy) NSString *zipCode;

- (NSArray *)validate;
-(NSString*) validateDate: (NSString*)value Length:(NSInteger)len;

@end
