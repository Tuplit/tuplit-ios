//
//  TLLeftMenuViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLUserProfileViewController.h"
#import "TLOtherUserProfileViewController.h"

@interface TLLeftMenuViewController : UITableViewController<UIScrollViewDelegate,TLUserDetailsManagerDelegate> {
    
    UILabel *userNameLbl, *creditBalanceLbl;
    EGOImageView *profileImageView;
    NSMutableArray *menuArray;
    IBOutlet UITableView *mTableView;
    
    NSNumberFormatter *numberFormatter;
    
    
//    TLUserProfileViewController *myProfileVC;
    TLOtherUserProfileViewController *friendProfileVC;
    TLMerchantsViewController *merchantVC;
    TLCartViewController *cartVC;
    TLFavouriteListViewController *favoriteVC;
    TLFriendsViewController *friendsVC;
    TLSettingsViewController *settingsVC;
}

@end
