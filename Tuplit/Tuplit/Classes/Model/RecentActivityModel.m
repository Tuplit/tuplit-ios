//
//  RecentActivityModel.m
//  Tuplit
//
//  Created by ev_mac11 on 24/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "RecentActivityModel.h"

@implementation RecentActivityModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.OrderId forKey:@"OrderId"];
    [encoder encodeObject:self.MerchantID forKey:@"MerchantID"];
    [encoder encodeObject:self.CompanyName forKey:@"CompanyName"];
    [encoder encodeObject:self.Location forKey:@"Location"];
    [encoder encodeObject:self.Icon forKey:@"Icon"];
    [encoder encodeObject:self.TotalItems forKey:@"TotalItems"];
    [encoder encodeObject:self.TotalPrice forKey:@"TotalPrice"];
    [encoder encodeObject:self.OrderDate forKey:@"OrderDate"];
    [encoder encodeObject:self.MerchantIcon forKey:@"MerchantIcon"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.OrderId = [decoder decodeObjectForKey:@"OrderId"];
        self.MerchantID = [decoder decodeObjectForKey:@"MerchantID"];
        self.CompanyName = [decoder decodeObjectForKey:@"CompanyName"];
        self.Location = [decoder decodeObjectForKey:@"Location"];
        self.Icon = [decoder decodeObjectForKey:@"Icon"];
        self.TotalItems = [decoder decodeObjectForKey:@"TotalItems"];
        self.TotalPrice = [decoder decodeObjectForKey:@"TotalPrice"];
        self.OrderDate = [decoder decodeObjectForKey:@"OrderDate"];
        self.MerchantIcon = [decoder decodeObjectForKey:@"MerchantIcon"];
    }
    return self;
}
@end
