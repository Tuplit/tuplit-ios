//
//  TLInviteFriendsViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 17/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//
#define INVITE_CELL_HEIGHT 51

#import <UIKit/UIKit.h>
#import "TLFacebookIDManager.h"
#import "TLFriendsInviteManager.h"
#import "CheckUserModel.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "Person.h"

@interface TLInviteFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,TLFacebookIDManagerDelegate,TLFriendsInviteManagerDelegate>
{
    UIView *baseView,*menuView;
    UITableView *facebookTable;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSInteger menuSelected;
}

@end
