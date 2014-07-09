//
//  OrderedFriendsListModel.m
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "OrderedFriendsListModel.h"

@implementation OrderedFriendsListModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.FirstName forKey:@"FirstName"];
    [encoder encodeObject:self.LastName forKey:@"LastName"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.FirstName = [decoder decodeObjectForKey:@"FirstName"];
        self.LastName = [decoder decodeObjectForKey:@"LastName"];
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
		      
    }
    return self;
}


@end
