//
//  SpecialsModel.m
//  Tuplit
//
//  Created by ev_mac11 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "SpecialProductsModel.h"

@implementation SpecialProductsModel

@synthesize quantity;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.ProductId forKey:@"ProductId"];
    [encoder encodeObject:self.ItemName forKey:@"ItemName"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    [encoder encodeObject:self.Price forKey:@"Price"];
    [encoder encodeObject:self.DiscountPrice forKey:@"DiscountPrice"];
    [encoder encodeObject:self.DiscountTier forKey:@"DiscountTier"];
    [encoder encodeObject:self.DiscountApplied forKey:@"DiscountApplied"];
    [encoder encodeObject:self.Ordering forKey:@"Ordering"];
    [encoder encodeObject:self.Status forKey:@"Status"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.ProductId = [decoder decodeObjectForKey:@"ProductId"];
        self.ItemName = [decoder decodeObjectForKey:@"ItemName"];
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
        self.Price = [decoder decodeObjectForKey:@"Price"];
        self.DiscountPrice = [decoder decodeObjectForKey:@"DiscountPrice"];
        self.DiscountTier = [decoder decodeObjectForKey:@"DiscountTier"];
        self.DiscountApplied = [decoder decodeObjectForKey:@"DiscountApplied"];
        self.Ordering = [decoder decodeObjectForKey:@"Ordering"];
        self.Status = [decoder decodeObjectForKey:@"Status"];
        
    }
    return self;
}


@end
