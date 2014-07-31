//
//  PaymentModel.m
//  Tuplit
//
//  Created by ev_mac14 on 18/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.UserId forKey:@"UserId"];
    [encoder encodeObject:self.PaymentAmount forKey:@"PaymentAmount"];
    [encoder encodeObject:self.CurrentBalance forKey:@"CurrentBalance"];
    [encoder encodeObject:self.AllowPayment forKey:@"AllowPayment"];
    [encoder encodeObject:self.Message forKey:@"Message"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.UserId = [decoder decodeObjectForKey:@"UserId"];
        self.PaymentAmount = [decoder decodeObjectForKey:@"PaymentAmount"];
        self.CurrentBalance = [decoder decodeObjectForKey:@"CurrentBalance"];
        self.AllowPayment = [decoder decodeObjectForKey:@"AllowPayment"];
        self.Message = [decoder decodeObjectForKey:@"Message"];
    }
    return self;
}

@end
