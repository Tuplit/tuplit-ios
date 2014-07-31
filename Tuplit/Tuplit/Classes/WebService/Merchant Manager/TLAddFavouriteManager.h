//
//  TLAddFavouriteManager.h
//  Tuplit
//
//  Created by ev_mac11 on 03/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLAddFavouriteManager;
@protocol TLAddFavouriteManagerDelegate <NSObject>
@optional
- (void)addFavouriteManagerSuccessfull:(TLAddFavouriteManager *) addFavouriteManager;
- (void)addFavouriteManager:(TLAddFavouriteManager *) addFavouriteManager returnedWithErrorCode:(NSString *)errorCode  errorMsg:(NSString *)errorMsg;
- (void)addFavouriteManagerFailed:(TLAddFavouriteManager *) addFavouritesManager;
@end

@interface TLAddFavouriteManager : NSObject

-(void)callService:(NSDictionary*)queryParams;
@property(nonatomic, unsafe_unretained) id <TLAddFavouriteManagerDelegate> delegate;
@end
