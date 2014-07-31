//
//  TLInviteListingManager.h
//  Tuplit
//
//  Created by ev_mac14 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLFriendsInviteManager;
@protocol TLFriendsInviteManagerDelegate <NSObject>
@optional
- (void)inviteManagerSuccess:(TLFriendsInviteManager *)inviteManager withinviteStatus:(NSString*)invitemessage;
- (void)inviteManager:(TLFriendsInviteManager *)inviteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)inviteManagerFailed:(TLFriendsInviteManager *)inviteManager;
@end

@interface TLFriendsInviteManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLFriendsInviteManagerDelegate> delegate;

@end
