//
//  TLCommentsListingManager.h
//  Tuplit
//
//  Created by ev_mac11 on 30/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLCommentsListingManager;
@protocol TLCommentsListingManagerDelegate <NSObject>
@optional
- (void)commentsListingManagerSuccess:(TLCommentsListingManager *)commentsListingManager withcommentsList:(NSArray*) _commentsList;
- (void)commentsListingManager:(TLCommentsListingManager *)commentsListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)commentsListingManagerFailed:(TLCommentsListingManager *)commentsListingManager;
@end

@interface TLCommentsListingManager : NSObject

-(void) callService:(NSString*)userId withStartCount:(int)start;
@property(nonatomic, unsafe_unretained) id <TLCommentsListingManagerDelegate> delegate;
@property(nonatomic, strong)NSArray *commentslist;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;
@end
