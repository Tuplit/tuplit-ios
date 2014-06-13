//
//  TLStaticContentManager.h
//  Tuplit
//
//  Created by ev_mac6 on 19/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLStaticContentManager;
@protocol TLStaticContentManagerDelegate <NSObject>
@optional
- (void)staticContentManagerSuccess:(TLStaticContentManager *)staticContentManager;
- (void)staticContentManager:(TLStaticContentManager *)staticContentManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)staticContentManagerFailed:(TLStaticContentManager *)staticContentManager;
@end


@interface TLStaticContentManager : NSObject
- (void)getStaticContents;
@property(nonatomic, unsafe_unretained) id <TLStaticContentManagerDelegate> delegate;
@end
