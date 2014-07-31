//
//  Person.m
//  Tuplit
//
//  Created by ev_mac11 on 21/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.contactImage forKey:@"contactImage"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.contactImage = [decoder decodeObjectForKey:@"contactImage"];
    }
    return self;
}

@end
