//
//  OrderedFriendsListModel.m
//  Tuplit
//
//  Created by ev_mac1 on 10/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "FriendsListModel.h"

@implementation FriendsListModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Id forKey:@"id"];
    [encoder encodeObject:self.FirstName forKey:@"FirstName"];
    [encoder encodeObject:self.LastName forKey:@"LastName"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    [encoder encodeObject:self.Email forKey:@"Email"];
    [encoder encodeObject:self.FBId forKey:@"FBId"];
    [encoder encodeObject:self.GooglePlusId forKey:@"GooglePlusId"];
    [encoder encodeObject:self.CompanyName forKey:@"CompanyName"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Id = [decoder decodeObjectForKey:@"id"];
        self.FirstName = [decoder decodeObjectForKey:@"FirstName"];
        self.LastName = [decoder decodeObjectForKey:@"LastName"];
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
        self.Email = [decoder decodeObjectForKey:@"Email"];
        self.FBId = [decoder decodeObjectForKey:@"FBId"];
         self.GooglePlusId = [decoder decodeObjectForKey:@"GooglePlusId"];
        self.CompanyName = [decoder decodeObjectForKey:@"CompanyName"];
		      
    }
    return self;
}


@end
