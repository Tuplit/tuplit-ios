//
//  TLFriendsListingManager.h
//  Tuplit
//
//  Created by ev_mac11 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsListModel.h"
#import "TLOtherUserProfileViewController.h"
@class TLFriendsListingManager;
@protocol TLFriendsListingManagerDelegate <NSObject>
@optional
- (void)friendsListingManagerSuccess:(TLFriendsListingManager *)friendsListingManager withFriendsListingManager:(NSArray*) _friendsList;
- (void)friendsListingManager:(TLFriendsListingManager *)friendsListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)friendsListingManagerFailed:(TLFriendsListingManager *)friendsListingManager;
@end

@interface TLFriendsListingManager : NSObject



@property(nonatomic, unsafe_unretained) id <TLFriendsListingManagerDelegate> delegate;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;

-(void) cancelRequest;
-(void)callService:(NSDictionary*)queryParams;

@end


