//
//  OrderProductModel.m
//  Tuplit
//
//  Created by ev_mac11 on 26/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "OrderProductModel.h"

@implementation OrderProductModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ProductID forKey:@"ProductID"];
    [encoder encodeObject:self.ItemName forKey:@"ItemName"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    [encoder encodeObject:self.ProductsQuantity forKey:@"ProductsQuantity"];
    [encoder encodeObject:self.ProductsCost forKey:@"ProductsCost"];
    [encoder encodeObject:self.DiscountPrice forKey:@"DiscountPrice"];
    [encoder encodeObject:self.TotalPrice forKey:@"TotalPrice"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.ProductID = [decoder decodeObjectForKey:@"ProductID"];
        self.ItemName = [decoder decodeObjectForKey:@"ItemName"];
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
        self.ProductsQuantity = [decoder decodeObjectForKey:@"ProductsQuantity"];
        self.ProductsCost = [decoder decodeObjectForKey:@"ProductsCost"];
        self.DiscountPrice = [decoder decodeObjectForKey:@"DiscountPrice"];
        self.TotalPrice = [decoder decodeObjectForKey:@"TotalPrice"];
    }
    return self;
}

@end
