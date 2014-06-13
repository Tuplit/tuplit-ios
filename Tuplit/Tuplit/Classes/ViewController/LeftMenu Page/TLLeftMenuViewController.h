//
//  TLLeftMenuViewController.h
//  Tuplit
//
//  Created by ev_mac6 on 25/04/14.
//  Copyright (c) 2014 alttab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLLeftMenuViewController : UITableViewController<UIScrollViewDelegate> {
    
    UILabel *userNameLbl, *creditBalanceLbl;
    EGOImageView *profileImageView;
    NSArray *menuArray;
    
    NSNumberFormatter *numberFormatter;
}

@end
