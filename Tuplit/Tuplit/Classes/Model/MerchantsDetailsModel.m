//
//  MerchantsDetailsModel.m
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "MerchantsDetailsModel.h"

@implementation MerchantsDetailsModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.MerchantId forKey:@"MerchantId"];
    [encoder encodeObject:self.FirstName forKey:@"FirstName"];
    [encoder encodeObject:self.LastName forKey:@"LastName"];
    [encoder encodeObject:self.Email forKey:@"Email"];
    
    [encoder encodeObject:self.CompanyName forKey:@"CompanyName"];
    [encoder encodeObject:self.Address forKey:@"Address"];
    [encoder encodeObject:self.Location forKey:@"Location"];
    [encoder encodeObject:self.Latitude forKey:@"Latitude"];
	[encoder encodeObject:self.Longitude forKey:@"Longitude"];
    
    [encoder encodeObject:self.PhoneNumber forKey:@"PhoneNumber"];
    [encoder encodeObject:self.WebsiteUrl forKey:@"WebsiteUrl"];
    [encoder encodeObject:self.Icon forKey:@"Icon"];
    [encoder encodeObject:self.Image forKey:@"Image"];
    [encoder encodeObject:self.Description forKey:@"Description"];
    
    [encoder encodeObject:self.ShortDescription forKey:@"ShortDescription"];
    [encoder encodeObject:self.distance forKey:@"distance"];
    [encoder encodeObject:self.DiscountTier forKey:@"DiscountTier"];
    [encoder encodeObject:self.DiscountType forKey:@"DiscountType"];
	[encoder encodeObject:self.DiscountProductId forKey:@"DiscountProductId"];
    
    [encoder encodeObject:self.SpecialIcon forKey:@"SpecialIcon"];
    [encoder encodeObject:self.ItemsSold forKey:@"ItemsSold"];
    [encoder encodeObject:self.OpeningHours forKey:@"OpeningHours"];
    [encoder encodeObject:self.PriceRange forKey:@"PriceRange"];
    [encoder encodeObject:self.SpecialsSold forKey:@"SpecialsSold"];
    [encoder encodeObject:self.IsGoldenTag forKey:@"IsGoldenTag"];
    [encoder encodeObject:self.AlreadyFavourited forKey:@"AlreadyFavourited"];
    [encoder encodeObject:self.Category forKey:@"Category"];
    [encoder encodeObject:self.OrderCount forKey:@"OrderCount"];
    [encoder encodeObject:self.OrderedFriendsCount forKey:@"OrderedFriendsCount"];
    [encoder encodeObject:self.CustomersCount forKey:@"CustomersCount"];
    [encoder encodeObject:self.TagType forKey:@"TagType"];

    
	[encoder encodeObject:self.OrderedFriendsList forKey:@"OrderedFriendsList"];
    [encoder encodeObject:self.Comments forKey:@"Comments"];
    [encoder encodeObject:self.slideshow forKey:@"slideshow"];
    
    [encoder encodeObject:self.ProductList forKey:@"ProductList"];
    
    [encoder encodeObject:self.SpecialProducts forKey:@"SpecialProducts"];
    [encoder encodeObject:self.DiscountProducts forKey:@"DiscountProducts"];
    [encoder encodeObject:self.MenuProducts forKey:@"MenuProducts"];
    [encoder encodeObject:self.CategoryList forKey:@"CategoryList"];
    

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.MerchantId = [decoder decodeObjectForKey:@"MerchantId"];
        self.FirstName = [decoder decodeObjectForKey:@"FirstName"];
        self.LastName = [decoder decodeObjectForKey:@"LastName"];
		self.Email = [decoder decodeObjectForKey:@"Email"];
        
        self.CompanyName = [decoder decodeObjectForKey:@"CompanyName"];
        self.Address = [decoder decodeObjectForKey:@"Address"];
        self.Location = [decoder decodeObjectForKey:@"Location"];
        self.Latitude = [decoder decodeObjectForKey:@"Latitude"];
        self.Longitude = [decoder decodeObjectForKey:@"Longitude"];
        
        self.PhoneNumber = [decoder decodeObjectForKey:@"PhoneNumber"];
        self.WebsiteUrl = [decoder decodeObjectForKey:@"WebsiteUrl"];
        self.Icon = [decoder decodeObjectForKey:@"Icon"];
        self.Image = [decoder decodeObjectForKey:@"Image"];
		self.Description = [decoder decodeObjectForKey:@"Description"];
        
        self.ShortDescription = [decoder decodeObjectForKey:@"ShortDescription"];
        self.distance = [decoder decodeObjectForKey:@"distance"];
        self.DiscountTier = [decoder decodeObjectForKey:@"DiscountTier"];
        self.DiscountType = [decoder decodeObjectForKey:@"DiscountType"];
        self.DiscountProductId = [decoder decodeObjectForKey:@"DiscountProductId"];
        
        self.SpecialIcon = [decoder decodeObjectForKey:@"SpecialIcon"];
        self.ItemsSold = [decoder decodeObjectForKey:@"ItemsSold"];
        self.OpeningHours = [decoder decodeObjectForKey:@"OpeningHours"];
        self.PriceRange = [decoder decodeObjectForKey:@"PriceRange"];
		self.Description = [decoder decodeObjectForKey:@"Description"];
        self.IsGoldenTag = [decoder decodeObjectForKey:@"IsGoldenTag"];
        self.AlreadyFavourited = [decoder decodeObjectForKey:@"AlreadyFavourited"];
        self.Category = [decoder decodeObjectForKey:@"Category"];
        self.OrderCount = [decoder decodeObjectForKey:@"OrderCount"];
        self.OrderedFriendsCount = [decoder decodeObjectForKey:@"OrderedFriendsCount"];
        self.CustomersCount = [decoder decodeObjectForKey:@"CustomersCount"];
        self.TagType = [decoder decodeObjectForKey:@"TagType"];
        
        self.OrderedFriendsList = [decoder decodeObjectForKey:@"OrderedFriendsList"];
        self.Comments = [decoder decodeObjectForKey:@"Comments"];
        self.slideshow = [decoder decodeObjectForKey:@"slideshow"];
        
        self.ProductList = [decoder decodeObjectForKey:@"ProductList"];
        
        self.SpecialProducts = [decoder decodeObjectForKey:@"SpecialProducts"];
        self.DiscountProducts = [decoder decodeObjectForKey:@"DiscountProducts"];
		self.MenuProducts = [decoder decodeObjectForKey:@"MenuProducts"];
        self.CategoryList = [decoder decodeObjectForKey:@"CategoryList"];
}
    return self;
}


@end
