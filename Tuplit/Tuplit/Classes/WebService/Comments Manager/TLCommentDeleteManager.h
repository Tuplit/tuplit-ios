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
- (void)commentDeleteManagerSuccess:(TLCommentDeleteManager *)commentDeleteManager;
- (void)commentDeleteManager:(TLCommentDeleteManager *)commentDeleteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)commentDeleteManagerFailed:(TLCommentDeleteManager *)commentDeleteManager;
@end

@interface TLCommentDeleteManager : NSObject

- (void)deleteComment:(NSString*)commentID;
@property(nonatomic, unsafe_unretained) id <TLCommentDeleteManagerDelegate> delegate;

@end
