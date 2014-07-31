//
//  TLEditProfileViewController.h
//  Tuplit
//
//  Created by ev_mac8 on 19/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileCell.h"
#import "UserDetailModel.h"
#import "TLCommentDeleteManager.h"
#import "TLUserDetailsManager.h"
#import "TLPinCodeViewController.h"
#import "PhotoMoveAndScaleController.h"
#import "TLEditUpdateManager.h"
#import "UserModel.h"
#import "TLCreditCardDeleteManager.h"

#define PROFILE_CELL_HEIGHT 52
#define HEADER_HEIGHT 40

#define kFirstName @"kFirstName"
#define kLastName @"kLastName"
#define kPhoto @"kPhoto"
#define kTPhoto @"kTPhoto"

@interface TLEditProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, EditProfileCellProtocol,TLCommentDeleteManagerDelegate,TLUserDetailsManagerDelegate,PhotoMoveAndScaleControllerDelegate,TLEditUpdateManagerDelegate,TLCreditCardDeleteManagerDelegate>
{
    
    UITableView *editProfileTable;
    
    CGFloat baseViewWidth, baseViewHeight;
    NSIndexPath *swipeIndexPath;

    NSDictionary *mainDict;
    NSMutableDictionary *nameDict;
    NSArray *sectionHeader;
}
@property(nonatomic,retain) UserDetailModel *userDetail;
@property(nonatomic,retain) NSString *pincode;
@property (nonatomic, retain)UserModel *user;
@end
