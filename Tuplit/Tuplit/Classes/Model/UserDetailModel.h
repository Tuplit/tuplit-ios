//
//  UserDetailModel.h
//  Tuplit
//
//  Created by ev_mac11 on 24/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserDetailModel : NSObject

@property (nonatomic, copy) UserModel *userModel;
@property (nonatomic, copy) NSArray *comments;
@property (nonatomic, copy) NSArray *Orders;
@property (nonatomic,copy)NSArray *UserLinkedCards;
@property (nonatomic,copy)NSArray *FriendsOrders;

@end
