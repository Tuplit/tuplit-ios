//
//  CheckUserModel.m
//  Tuplit
//
//  Created by ev_mac14 on 18/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CheckUserModel.h"

@implementation CheckUserModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.AlreadyInvited forKey:@"AlreadyInvited"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.picture forKey:@"picture"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.AlreadyInvited = [decoder decodeObjectForKey:@"AlreadyInvited"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.picture = [decoder decodeObjectForKey:@"picture"];
    }
    return self;
}


@end
