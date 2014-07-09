//
//  TLAddCommentManager.h
//  Tuplit
//
//  Created by ev_mac11 on 01/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TLAddCommentManager;
@protocol TLAddCommentManagerDelegate <NSObject>
@optional
- (void)commentAddManagerSuccess:(TLAddCommentManager *)loginManager;
- (void)commentAddManager:(TLAddCommentManager *)loginManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)commentAddManagerFailed:(TLAddCommentManager *)loginManager;
@end

@interface TLAddCommentManager : NSObject

- (void)addComment:(NSDictionary*)queryParam;
@property(nonatomic, unsafe_unretained) id <TLAddCommentManagerDelegate> delegate;
@end
