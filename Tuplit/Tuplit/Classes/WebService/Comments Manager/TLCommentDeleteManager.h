//
//  TLCommentDeleteManager.h
//  Tuplit
//
//  Created by ev_mac11 on 27/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLCommentDeleteManager;
@protocol TLCommentDeleteManagerDelegate <NSObject>
@optional
- (void)commentDeleteManagerSuccess:(TLCommentDeleteManager *)loginManager;
- (void)commentDeleteManager:(TLCommentDeleteManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)commentDeleteManagerFailed:(TLCommentDeleteManager *)loginManager;
@end

@interface TLCommentDeleteManager : NSObject

- (void)deleteComment:(NSString*)commentID;
@property(nonatomic, unsafe_unretained) id <TLCommentDeleteManagerDelegate> delegate;

@end
