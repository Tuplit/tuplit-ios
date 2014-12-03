//
//  TLOtherUserProfileViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 09/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLEditProfileViewController.h"
#import "UserProfileCell.h"
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

#define PROFILE_CELL_HEIGHT 52
#define HEADER_HEIGHT 40

@interface TLOtherUserProfileViewController :  UIViewController <UITableViewDataSource,UITableViewDelegate,UserProfileCellProtocol,TLUserDetailsManagerDelegate,TLCreditCardListingManagerDelegate>
{
    UIImage * creditCardImage;
    UITableView *userProfileTable;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSIndexPath *swipeIndexPath;
    
    UserDetailModel *userdeatilmodel;
    UserModel *userModel;
    
    NSDictionary *mainDict;
    NSArray *sectionHeader;
    int totalOrders,totalComments;
}
-(void)reloadOtherUserprofile;
@property (nonatomic,strong)NSString *userID;
@property BOOL isLeftMenu;
@end
