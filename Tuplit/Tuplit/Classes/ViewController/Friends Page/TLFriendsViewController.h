//
//  TLFriendsViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLInviteFriendsViewController.h"
#import "TLFriendsListingManager.h"
#import "FriendsListModel.h"

#define FRIENDS_CEL_HEIGHT 51

@interface TLFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TLFriendsListingManagerDelegate>

{
    UITableView *friendsTable;
    UIView *baseView,*searchbarView;
    
    CGFloat baseViewWidth,baseViewHeight;
    
    NSMutableArray *friendsArray;
    
    UIRefreshControl *refreshControl;
    UIView *cellContainer;
    int totalUserListCount,lastFetchCount,keyboardHeight;
    BOOL isLoadMorePressed,isPullRefreshPressed,isFriendsWebserviceRunning;
}

-(void)reloadFriends;
@end
