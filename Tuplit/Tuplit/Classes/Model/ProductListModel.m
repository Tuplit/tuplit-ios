//
//  ProductListModel.m
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "ProductListModel.h"

@implementation ProductListModel
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.SpecialProducts forKey:@"SpecialProducts"];
    [encoder encodeObject:self.DiscountProducts forKey:@"DiscountProducts"];
    [encoder encodeObject:self.MenuProducts forKey:@"MenuProducts"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.SpecialProducts = [decoder decodeObjectForKey:@"SpecialProducts"];
        self.DiscountProducts = [decoder decodeObjectForKey:@"DiscountProducts"];
        self.MenuProducts = [decoder decodeObjectForKey:@"MenuProducts"];
    }
    return self;
}

@end
