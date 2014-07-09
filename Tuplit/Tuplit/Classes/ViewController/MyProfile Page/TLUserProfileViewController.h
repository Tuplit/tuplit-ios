//
//  TLUserProfileViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLEditProfileViewController.h"
#import "UserProfileCell.h"
#import "TopUpViewController.h"
#import "TopUpViewController2.h"
#import "TLAllTransactionsViewController.h"
#import "TLAddCreditCardViewController.h"
#import "TLUserDetailsManager.h"
#import "UserModel.h"
#import "UserDetailModel.h"
#import "UserCommentsModel.h"
#import "RecentActivityModel.h"
#import "TLAllCommentsViewController.h"

#define PROFILE_CELL_HEIGHT 52
#define HEADER_HEIGHT 40

@interface TLUserProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UserProfileCellProtocol,TLUserDetailsManagerDelegate>
{
   
    UIImage * creditCardImage;
    UITableView *userProfileTable;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSIndexPath *swipeIndexPath;

    UserDetailModel *userdeatilmodel;
    
    NSDictionary *mainDict;
    NSArray *sectionHeader;
}

@end
