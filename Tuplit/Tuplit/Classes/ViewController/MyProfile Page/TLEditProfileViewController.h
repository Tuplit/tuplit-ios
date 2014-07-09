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

#define PROFILE_CELL_HEIGHT 52
#define HEADER_HEIGHT 40

@interface TLEditProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate, EditProfileCellProtocol,TLCommentDeleteManagerDelegate,TLUserDetailsManagerDelegate,PhotoMoveAndScaleControllerDelegate,TLEditUpdateManagerDelegate,UINavigationControllerDelegate>
{
    
    UITableView *editProfileTable;
    
    CGFloat baseViewWidth, baseViewHeight;
    NSIndexPath *swipeIndexPath;

    NSDictionary *mainDict;
    NSArray *sectionHeader;
}
@property(nonatomic,retain) UserDetailModel *userDetail;
@property(nonatomic,retain) NSString *pincode;
@property (nonatomic, retain)UserModel *user;
@end
