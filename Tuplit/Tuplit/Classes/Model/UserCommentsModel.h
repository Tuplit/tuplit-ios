//
//  UserCommentsModel.h
//  Tuplit
//
//  Created by ev_mac11 on 24/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCommentsModel : NSObject

@property (nonatomic, copy)NSString *CommentId;
@property (nonatomic, copy)NSString *CommentsText;
@property (nonatomic, copy)NSString *CommentDate;
@property (nonatomic, copy)NSString *UserPhoto;
@property (nonatomic, copy)NSString *UserId;
@property (nonatomic, copy)NSString *UserName;
@property (nonatomic, copy)NSString *merchantId;
@property (nonatomic, copy)NSString *MerchantName;
@property (nonatomic, copy)NSString *MerchantIcon;

@end
