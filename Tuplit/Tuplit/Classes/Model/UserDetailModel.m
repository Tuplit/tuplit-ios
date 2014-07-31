//
//  UserDetailModel.m
//  Tuplit
//
//  Created by ev_mac11 on 24/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UserDetailModel.h"

@implementation UserDetailModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.userModel forKey:@"Details"];
    [encoder encodeObject:self.comments forKey:@"comments"];
    [encoder encodeObject:self.Orders forKey:@"Orders"];
    [encoder encodeObject:self.UserLinkedCards forKey:@"UserLinkedCards"];
     [encoder encodeObject:self.UserLinkedCards forKey:@"FriendsOrders"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	
    if ((self = [super init])) {
        
        self.userModel = [decoder decodeObjectForKey:@"Details"];
        self.comments = [decoder decodeObjectForKey:@"comments"];
        self.Orders = [decoder decodeObjectForKey:@"Orders"];
        self.UserLinkedCards = [decoder decodeObjectForKey:@"UserLinkedCards"];
        self.UserLinkedCards = [decoder decodeObjectForKey:@"FriendsOrders"];
        
    }
    return self;
}

@end
