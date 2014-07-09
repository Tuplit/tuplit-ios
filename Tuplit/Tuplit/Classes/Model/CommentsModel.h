//
//  CommentsModel.h
//  Tuplit
//
//  Created by ev_mac11 on 09/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject

@property (nonatomic, copy) NSString * UserId;
@property (nonatomic, copy) NSString * FirstName;
@property (nonatomic, copy) NSString * LastName;
@property (nonatomic, copy) NSString * Photo;
@property (nonatomic, copy) NSString * CommentsText;
@property (nonatomic, copy) NSString * CommentDate;


@end
