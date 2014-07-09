//
//  UserCommentsModel.m
//  Tuplit
//
//  Created by ev_mac11 on 24/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "UserCommentsModel.h"

@implementation UserCommentsModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.CommentId forKey:@"CommentId"];
    [encoder encodeObject:self.CommentsText forKey:@"CommentsText"];
    [encoder encodeObject:self.CommentDate forKey:@"CommentDate"];
    [encoder encodeObject:self.UserPhoto forKey:@"UserPhoto"];
    [encoder encodeObject:self.UserId forKey:@"UserId"];
    [encoder encodeObject:self.UserName forKey:@"UserName"];
    [encoder encodeObject:self.merchantId forKey:@"merchantId"];
    [encoder encodeObject:self.MerchantName forKey:@"MerchantName"];
    [encoder encodeObject:self.MerchantIcon forKey:@"MerchantIcon"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.CommentId = [decoder decodeObjectForKey:@"CommentId"];
        self.CommentsText = [decoder decodeObjectForKey:@"CommentsText"];
        self.CommentDate = [decoder decodeObjectForKey:@"CommentDate"];
        self.UserPhoto = [decoder decodeObjectForKey:@"UserPhoto"];
        self.UserId = [decoder decodeObjectForKey:@"UserId"];
        self.UserName = [decoder decodeObjectForKey:@"UserName"];
        self.merchantId = [decoder decodeObjectForKey:@"merchantId"];
        self.MerchantName = [decoder decodeObjectForKey:@"MerchantName"];
        self.MerchantIcon = [decoder decodeObjectForKey:@"MerchantIcon"];
    }
    return self;
}


@end
