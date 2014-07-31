//
//  TLTransferViewController.h
//  Tuplit
//
//  Created by ev_mac11 on 15/07/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTransferManager.h"
#import "TLPinCodeViewController.h"
#import "FriendsListModel.h"
#import "TLFriendsListingManager.h"

@interface TLTransferViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,TLTransferDelegate,TLPinCodeVerifiedDelegate,TLFriendsListingManagerDelegate>
{
    UITextField *amountTxt,*toTxt;
    UIView *baseView;
    UITableView *toProfileNameTable;
    UIBarButtonItem *previous,*next;
    UILabel *placeholderLbl;
    UITextView *messageTxtView;
    
    NSMutableArray *tableArray;
    CGFloat baseViewWidth,baseViewHeight;
    NSInteger index;
    
    NSString *amountText;
}
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *UserName;
@end
