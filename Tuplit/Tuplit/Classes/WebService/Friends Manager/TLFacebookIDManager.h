//
//  TLFacebookIDManager.h
//  Tuplit
//
//  Created by ev_mac14 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"CheckUserModel.h"

@class TLFacebookIDManager;
@protocol TLFacebookIDManagerDelegate <NSObject>
@optional
- (void)fbIDManagerSuccess:(TLFacebookIDManager *)fbIDManager withFriendsListingManager:(NSArray*)_fbfriendsList;
- (void)fbIDManager:(TLFacebookIDManager *)fbIDManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)fbIDManagerFailed:(TLFacebookIDManager *)fbIDManager;
@end

@interface TLFacebookIDManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLFacebookIDManagerDelegate> delegate;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;

@end
