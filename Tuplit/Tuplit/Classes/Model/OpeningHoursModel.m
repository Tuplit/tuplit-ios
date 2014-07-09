//
//  HoursAndPriceModel.m
//  Tuplit
//
//  Created by ev_mac11 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "OpeningHoursModel.h"

@implementation OpeningHoursModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Open forKey:@"Open"];
    [encoder encodeObject:self.Closed forKey:@"Closed"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Open = [decoder decodeObjectForKey:@"Open"];
        self.Closed = [decoder decodeObjectForKey:@"Closed"];

    }
    return self;
}


@end
