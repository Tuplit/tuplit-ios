//
//  TLLoginManager.h
//  Tuplit
//
//  Created by ev_mac6 on 28/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import "TLLoginManager.h"
#import "UserModel.h"

@class TLLoginManager;
@protocol TLLoginManagerDelegate <NSObject>
@optional
- (void)loginManager:(TLLoginManager *)loginManager loginSuccessfullWithUser:(UserModel *)user;
- (void)loginManager:(TLLoginManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)loginManagerLoginFailed:(TLLoginManager *)loginManager;
@end


@interface TLLoginManager : NSObject

- (void)loginUserUsingSocialNW:(BOOL)isSocialNW;

@property(nonatomic,retain) UserModel * user;
@property(nonatomic, unsafe_unretained) id <TLLoginManagerDelegate> delegate;

@end
