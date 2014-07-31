//
//  CreditCardModel.m
//  Tuplit
//
//  Created by ev_mac11 on 07/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CreditCardModel.h"

@implementation CreditCardModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.CardNumber forKey:@"CardNumbar"];
    [encoder encodeObject:self.CardType forKey:@"CardType"];
    [encoder encodeObject:self.ExpirationDate forKey:@"ExpirationDate"];
    [encoder encodeObject:self.Currency forKey:@"Currency"];
    [encoder encodeObject:self.Image forKey:@"Image"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.CardNumber = [decoder decodeObjectForKey:@"CardNumbar"];
        self.CardType = [decoder decodeObjectForKey:@"CardType"];
        self.ExpirationDate = [decoder decodeObjectForKey:@"ExpirationDate"];
        self.Currency = [decoder decodeObjectForKey:@"Currency"];
        self.Image = [decoder decodeObjectForKey:@"Image"];
    }
    return self;
}


@end
