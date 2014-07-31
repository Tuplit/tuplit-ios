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
#import "TLTopUpViewController.h"
#import "TLAllTransactionsViewController.h"
#import "TLAddCreditCardViewController.h"
#import "TLUserDetailsManager.h"
#import "TLCreditCardListingManager.h"
#import "CreditCardModel.h"
#import "UserModel.h"
#import "UserDetailModel.h"
#import "UserCommentsModel.h"
#import "RecentActivityModel.h"
#import "TLAllCommentsViewController.h"
#import "TLCreditCardDeleteManager.h"
#import "TLTransferViewController.h"

#define PROFILE_CELL_HEIGHT 52
#define HEADER_HEIGHT 40

@interface TLUserProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UserProfileCellProtocol,TLUserDetailsManagerDelegate,TLCreditCardListingManagerDelegate,TLCreditCardDeleteManagerDelegate>
{
   
    UIImage * creditCardImage;
    UITableView *userProfileTable;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSIndexPath *swipeIndexPath;

    UserDetailModel *userdeatilmodel;
    
    NSDictionary *mainDict;
    NSArray *sectionHeader;
    int totalOrders,totalComments;
}

@end
