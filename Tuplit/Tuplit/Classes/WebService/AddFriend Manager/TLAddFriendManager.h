//
//  TLAddFriendManager.h
//  Tuplit
//
//  Created by ev_mac11 on 06/12/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLAddFriendManager;
@protocol TLAddFriendManagerDelegate <NSObject>
@optional
- (void)addFriendManagerSuccessfull:(TLAddFriendManager *) addFriendManager;
- (void)addFriendManager:(TLAddFriendManager *) addFriendManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)addFriendManagerFailed:(TLAddFriendManager *) addFriendManager;
@end

@interface TLAddFriendManager : NSObject

-(void)callService:(NSString*)userID;
@property(nonatomic, unsafe_unretained) id <TLAddFriendManagerDelegate> delegate;
@end
