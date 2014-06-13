//
//  CategoryModel.m
//  Tuplit
//
//  Created by ev_mac5 on 31/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.CategoryId forKey:@"CategoryId"];
    [encoder encodeObject:self.CategoryIcon forKey:@"CategoryIcon"];
    [encoder encodeObject:self.CategoryName forKey:@"CategoryName"];
    [encoder encodeObject:self.MerchantCount forKey:@"MerchantCount"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.CategoryId = [decoder decodeObjectForKey:@"CategoryId"];
        self.CategoryIcon = [decoder decodeObjectForKey:@"CategoryIcon"];
        self.CategoryName = [decoder decodeObjectForKey:@"CategoryName"];
        self.MerchantCount = [decoder decodeObjectForKey:@"MerchantCount"];
		      
    }
    return self;
}


@end
