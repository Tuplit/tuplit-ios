//
//  MenuProductsModel.m
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "MenuProductsModel.h"

@implementation MenuProductsModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.CategoryId forKey:@"CategoryId"];
    [encoder encodeObject:self.CategoryName forKey:@"CategoryName"];
    [encoder encodeObject:self.Items forKey:@"Items"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.CategoryId = [decoder decodeObjectForKey:@"CategoryId"];
        self.CategoryName = [decoder decodeObjectForKey:@"CategoryName"];
        self.Items = [decoder decodeObjectForKey:@"Items"];
    }
    return self;
}

@end
