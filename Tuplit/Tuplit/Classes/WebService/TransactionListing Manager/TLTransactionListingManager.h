//
//  TLTransactionListingManager.h
//  Tuplit
//
//  Created by ev_mac11 on 23/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLTransactionListingManager;
@protocol TLTransactionListingManagerDelegate <NSObject>
@optional
- (void)transactionListingManagerSuccess:(TLTransactionListingManager *)trancactionListingManager withTrancactionListingManager:(NSArray*) _transactionList;
- (void)transactionListingManager:(TLTransactionListingManager *)trancactionListingManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)transactionListingManagerFailed:(TLTransactionListingManager *)trancactionListingManager;
@end

@interface TLTransactionListingManager : NSObject

-(void) callService:(NSString*)userId withStartCount:(int)start;

@property(nonatomic, unsafe_unretained) id <TLTransactionListingManagerDelegate> delegate;
@property(nonatomic, strong)NSArray *trancactionlist;
@property(nonatomic, assign) long listedCount;
@property(nonatomic, assign) long totalCount;
@end
