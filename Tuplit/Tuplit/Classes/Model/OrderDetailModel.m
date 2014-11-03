//
//  OrderDetailModel.m
//  Tuplit
//
//  Created by ev_mac11 on 26/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.OrderId forKey:@"OrderId"];
    [encoder encodeObject:self.CartId forKey:@"CartId"];
    [encoder encodeObject:self.UserId forKey:@"UserId"];
    [encoder encodeObject:self.MerchantId forKey:@"MerchantId"];
    [encoder encodeObject:self.TotalPrice forKey:@"TotalPrice"];
    [encoder encodeObject:self.TransactionId forKey:@"TransactionId"];
    [encoder encodeObject:self.CompanyName forKey:@"CompanyName"];
    [encoder encodeObject:self.Address forKey:@"Address"];
    [encoder encodeObject:self.Location forKey:@"Location"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    [encoder encodeObject:self.FirstName forKey:@"FirstName"];
    [encoder encodeObject:self.LastName forKey:@"LastName"];
    [encoder encodeObject:self.Email forKey:@"Email"];
    [encoder encodeObject:self.OrderDate forKey:@"OrderDate"];
    [encoder encodeObject:self.OrderDoneBy forKey:@"OrderDoneBy"];
    [encoder encodeObject:self.UniqueId forKey:@"UniqueId"];
    [encoder encodeObject:self.SubTotal forKey:@"SubTotal"];
    [encoder encodeObject:self.VAT forKey:@"VAT"];
    [encoder encodeObject:self.Products forKey:@"Products"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.OrderId = [decoder decodeObjectForKey:@"OrderId"];
        self.CartId = [decoder decodeObjectForKey:@"CartId"];
        self.UserId = [decoder decodeObjectForKey:@"UserId"];
        self.MerchantId = [decoder decodeObjectForKey:@"MerchantId"];
        self.TotalPrice = [decoder decodeObjectForKey:@"TotalPrice"];
        self.TransactionId = [decoder decodeObjectForKey:@"TransactionId"];
        self.CompanyName = [decoder decodeObjectForKey:@"CompanyName"];
        self.Address = [decoder decodeObjectForKey:@"Address"];
        self.Location = [decoder decodeObjectForKey:@"Location"];
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
        self.FirstName = [decoder decodeObjectForKey:@"FirstName"];
        self.LastName = [decoder decodeObjectForKey:@"LastName"];
        self.Email = [decoder decodeObjectForKey:@"Email"];
        self.OrderDate = [decoder decodeObjectForKey:@"OrderDate"];
        self.OrderDoneBy = [decoder decodeObjectForKey:@"OrderDoneBy"];
        self.UniqueId = [decoder decodeObjectForKey:@"UniqueId"];
        self.SubTotal = [decoder decodeObjectForKey:@"SubTotal"];
        self.VAT = [decoder decodeObjectForKey:@"VAT"];
        self.Products = [decoder decodeObjectForKey:@"Products"];
    }
    return self;
}

@end
