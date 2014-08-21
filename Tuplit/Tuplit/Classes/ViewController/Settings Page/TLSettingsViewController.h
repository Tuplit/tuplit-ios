//
//  TLSettingsViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 15/05/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TLSettingsManager.h"
@interface TLSettingsViewController : UIViewController<MFMailComposeViewControllerDelegate,TLSettingsManagerDelegate>
@property(strong,nonatomic)UserModel *user_model;
@end
