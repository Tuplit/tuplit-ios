//
//  TLAddCreditCardViewController.h
//  Tuplit
//
//  Created by ev_mac2 on 22/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSettingsViewController.h"
#import "CustomSwitch.h"
#import "CardIOPaymentViewControllerDelegate.h"
#import "CardIO.h"
#import "TuplitConstants.h"
#import "TLAddCreditCardManager.h"

@interface TLAddCreditCardViewController : UIViewController<TLAddCreditCardManagerDelegate>

@property(nonatomic,weak)UIViewController*viewController;
@property(nonatomic,strong) NSString *topupAmout;
@end
