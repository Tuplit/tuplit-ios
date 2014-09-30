//
//  MerchantModel.m
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "MerchantModel.h"

@implementation MerchantModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.MerchantID forKey:@"id"];
    [encoder encodeObject:self.Icon forKey:@"Icon"];
    [encoder encodeObject:self.Image forKey:@"Image"];
    [encoder encodeObject:self.DiscountTier forKey:@"DiscountTier"];
    [encoder encodeObject:self.CompanyName forKey:@"CompanyName"];
    [encoder encodeObject:self.ShortDescription forKey:@"ShortDescription"];
    [encoder encodeObject:self.Address forKey:@"Address"];
    [encoder encodeObject:self.ItemsSold forKey:@"ItemsSold"];
    [encoder encodeObject:self.Latitude forKey:@"Latitude"];
    [encoder encodeObject:self.Longitude forKey:@"Longitude"];
    [encoder encodeObject:self.distance forKey:@"distance"];
    [encoder encodeObject:self.IsSpecial forKey:@"IsSpecial"];
    [encoder encodeObject:self.IsGoldenTag forKey:@"IsGoldenTag"];
    [encoder encodeObject:self.NewTag forKey:@"NewTag"];
    [encoder encodeObject:self.Category forKey:@"Category"];
    [encoder encodeObject:self.TotalUsersShopped forKey:@"TotalUsersShopped"];
    [encoder encodeObject:self.TagType forKey:@"TagType"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.MerchantID = [decoder decodeObjectForKey:@"id"];
        self.Icon = [decoder decodeObjectForKey:@"Icon"];
        self.Image = [decoder decodeObjectForKey:@"Image"];
        self.DiscountTier = [decoder decodeObjectForKey:@"DiscountTier"];
        self.CompanyName = [decoder decodeObjectForKey:@"CompanyName"];
        self.ShortDescription = [decoder decodeObjectForKey:@"ShortDescription"];
        self.Address = [decoder decodeObjectForKey:@"Address"];
        self.ItemsSold = [decoder decodeObjectForKey:@"ItemsSold"];
        self.Latitude = [decoder decodeObjectForKey:@"Latitude"];
        self.Longitude = [decoder decodeObjectForKey:@"Longitude"];
        self.distance = [decoder decodeObjectForKey:@"distance"];
        self.IsSpecial = [decoder decodeObjectForKey:@"IsSpecial"];
        self.IsGoldenTag = [decoder decodeObjectForKey:@"IsGoldenTag"];
        self.NewTag = [decoder decodeObjectForKey:@"NewTag"];
        self.Category = [decoder decodeObjectForKey:@"Category"];
        self.TotalUsersShopped = [decoder decodeObjectForKey:@"TotalUsersShopped"];
        self.TagType = [decoder decodeObjectForKey:@"TagType"];
        
    }
    return self;
}

@end
