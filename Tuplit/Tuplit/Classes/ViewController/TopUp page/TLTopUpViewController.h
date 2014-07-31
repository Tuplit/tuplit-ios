//
//  TopUpViewController2.h
//  Tuplit
//
//  Created by ev_mac8 on 13/06/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLUserProfileViewController.h"
#import "TLTopupManager.h"
#import "UserDetailModel.h"
#import "CreditCardModel.h"
#import "TuplitConstants.h"
#import "TLAddCreditCardViewController.h"
#import "TLCreditCardListingManager.h"

@interface TLTopUpViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,TLTopupManagerDelegate,TLCreditCardListingManagerDelegate>
{
    UIButton *tenRupeeTopUpBtn,*twentyRupeeTopUpBtn;
    UIButton *fiftyRupeeTopUpBtn;
    UITextField *topUpAmountTxt;
    UITableView *topupTable;
    
    CGFloat baseViewWidth,baseViewHeight;
    NSString *amount;
    NSString *value,*appendString;
    NSString *valueStr,*cardTypeStr;
    NSInteger amtType;
    NSDictionary *cardDetailDict;
    
//    CreditCardModel *creditCard;
    
}

@property(nonatomic,retain) UserDetailModel *userdeatilmodel;
@property(nonatomic,strong)NSArray *userLinkedCards;

@end
