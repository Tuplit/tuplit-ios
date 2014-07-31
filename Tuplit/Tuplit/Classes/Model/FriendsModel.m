//
//  FriendsModel.m
//  Tuplit
//
//  Created by ev_mac5 on 22/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "FriendsModel.h"

@implementation FriendsModel

@synthesize Photo,FriendName,lastName,MerchantName,FriendId;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    [encoder encodeObject:self.FriendName forKey:@"FriendName"];
    [encoder encodeObject:self.MerchantName forKey:@"MerchantName"];
    [encoder encodeObject:self.FriendId forKey:@"FriendId"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
        self.FriendName = [decoder decodeObjectForKey:@"FriendName"];
        self.MerchantName = [decoder decodeObjectForKey:@"MerchantName"];
        self.FriendId = [decoder decodeObjectForKey:@"FriendId"];
    }
    return self;
}


@end
