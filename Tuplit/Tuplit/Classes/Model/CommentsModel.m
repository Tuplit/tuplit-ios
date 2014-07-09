//
//  CommentsModel.m
//  Tuplit
//
//  Created by ev_mac11 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.UserId forKey:@"UserId"];
    [encoder encodeObject:self.FirstName forKey:@"FirstName"];
    [encoder encodeObject:self.LastName forKey:@"LastName"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    [encoder encodeObject:self.CommentsText forKey:@"CommentsText"];
    [encoder encodeObject:self.Photo forKey:@"Photo"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.UserId = [decoder decodeObjectForKey:@"UserId"];
        self.FirstName = [decoder decodeObjectForKey:@"FirstName"];
        self.LastName = [decoder decodeObjectForKey:@"LastName"];
        self.Photo = [decoder decodeObjectForKey:@"Photo"];
        self.CommentsText = [decoder decodeObjectForKey:@"CommentsText"];
        self.CommentDate = [decoder decodeObjectForKey:@"CommentDate"];
        
    }
    return self;
}


@end
